-- Run once in Supabase SQL Editor. Enables anonymous Auth in dashboard separately.
create schema if not exists exam_private;
create table if not exists public.exam_submissions (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id),
 student_name text not null check (length(student_name) between 2 and 100),
 student_email text not null check (length(student_email) between 3 and 254),
 answers integer[] not null check (array_length(answers,1)=15),
 score integer,
 submitted_at timestamptz not null default now()
);
alter table public.exam_submissions enable row level security;
revoke all on public.exam_submissions from anon, authenticated;
grant insert on public.exam_submissions to authenticated;
create policy "submit own exam" on public.exam_submissions for insert to authenticated
 with check (user_id = (select auth.uid()) and score is null);
-- Grade answer keys are stored only in the database, never in public GitHub source.
create or replace function exam_private.grade_submission()
returns trigger language plpgsql security definer set search_path = '' as $$
declare key integer[] := array[1,2,2,1,2,2,2,2,1,3,2,1,1,1,3]; i integer; total integer := 0;
begin
 if new.user_id is distinct from auth.uid() then raise exception 'Invalid submission owner'; end if;
 if new.score is not null then raise exception 'Score must not be supplied'; end if;
 for i in 1..15 loop
  if new.answers[i] is not null and new.answers[i] = key[i] then total := total + 1; end if;
 end loop;
 new.score := total;
 return new;
end; $$;
revoke all on function exam_private.grade_submission() from public, anon, authenticated;
drop trigger if exists grade_on_submission on public.exam_submissions;
create trigger grade_on_submission before insert on public.exam_submissions
 for each row execute function exam_private.grade_submission();
-- Owner/admin: select student_name, student_email, score, submitted_at from public.exam_submissions order by submitted_at desc;
