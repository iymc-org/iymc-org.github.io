# IYMC Final Exam — Independent Assessment

Independent Grade 7 mathematics exam website. Not an official IYMC website.

## Supabase
1. Open Supabase > SQL Editor and run `schema.sql`.
2. Authentication > Providers > Anonymous Sign-Ins: enable.
3. Project Settings > API: verify the URL and publishable key in `config.js`.
4. Realtime must be enabled for channel broadcasts. This uses Supabase Realtime to send *only a heartbeat*, not video. The QR is generated via qrserver.com and includes the public phone pairing URL.
5. Results: SQL Editor: `select student_name, student_email, score, submitted_at from public.exam_submissions order by submitted_at desc;`

## GitHub Pages
1. Create a new **public** repository `mathematics-final-exam`.
2. Upload `index.html`, `main.js`, `config.js`, `schema.sql`, `README.md`, `iymc-logo.png`, `favicon.png` to the repository root.
3. Settings > Pages > Build and deployment > Deploy from a branch > `main` / `(root)` > Save.
4. Wait for the Pages deployment, then open `https://YOUR_USERNAME.github.io/mathematics-final-exam/`.
5. Test laptop camera, QR phone connection, 15-question timer and submission with a dummy student first.

## Important
- Do not upload a Supabase service_role key, secret key, or database password to GitHub.
- The current version is **not a hardened proctoring system**. The browser timer can be manipulated, a student can restart, and anonymous users can submit multiple attempts. For strict one-attempt rules, server-side sessions, time enforcement, and secure student authentication are required.
- The phone camera remains local to the phone; the laptop does **not** receive or monitor its video. A heartbeat merely signals that the phone page reports its camera track active.
- Email is **not automatically sent**; review results in Supabase and email manually.
- The QR generation uses an external image service. If unavailable, open the direct phone link.
- Ask a parent/guardian before using a child's camera and storing their name/email.
