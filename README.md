# Personal Developer Portfolio

A small, industrial-style developer portfolio for completed C, web, and other software projects. Work in progress is represented by a construction-tape banner only; the public site does not reveal its titles or descriptions.

## Personalize it

Edit `src/config.js` to set your name, role, location, introduction, email, GitHub, and LinkedIn. Your name is kept in one place. Do not put private or unfinished project details in this file.

## Local preview

1. Install Node.js 20.19+ or 22.12+.
2. Copy `.env.example` to `.env` and fill the Supabase project URL and publishable/anon key.
3. Follow **Set up Supabase** below.
4. Run `pnpm install`, then `pnpm dev` (or use npm if that is your usual package manager).
5. Open the local URL shown by Vite. The owner area is at `/#/admin`.

You can also run `pnpm check` for the included static security/configuration checks and `pnpm build` to create the production bundle in `dist/`.

## Open it in Visual Studio Code on Windows

1. Extract the project ZIP, open Visual Studio Code, and choose **File → Open Folder**. Select the `Arryan-Rana-Portfolio` folder.
2. To see the design without installing anything, press **Ctrl+Shift+P**, choose **Tasks: Run Task**, then choose **Portfolio: Open quick preview**. This opens `preview.html` in your browser.
3. To run the full app, install Node.js if it is not already installed. In Visual Studio Code, choose **Terminal → Run Task → Portfolio: Install dependencies** once. When it finishes, choose **Terminal → Run Task → Portfolio: Start full website**. Your browser opens the running site.
4. The full app needs Supabase configuration before its live project gallery and owner admin can work. Follow **Set up Supabase** below. The quick preview is a visual sample and does not upload projects.

## Set up Supabase

1. Create a Supabase project and keep its database region near your likely visitors.
2. In **Authentication → Providers / Sign In**, turn off public email signups. Create your one owner account from the Supabase dashboard; do not build an open registration flow.
3. Copy the owner user's UUID from **Authentication → Users**.
4. Open `supabase/schema.sql`, replace every `OWNER_AUTH_USER_UUID` with that UUID, and run it in the SQL Editor. RLS must remain enabled.
5. Copy the project URL and publishable (or legacy anon) key to `.env` as `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY`. The publishable/anon key is designed to be public; the table's row-level security is what protects records. Never put a service-role or secret key in this app or its environment variables.
6. Under **Authentication → URL Configuration**, allow your deployed origin and local preview origin in the site URL and redirect URL list. Keep this list limited to domains you control.
7. In **Authentication → Security and Protection**, set a strong minimum password length, enable breached-password protection where available, and enroll the owner in MFA. Use a unique password stored in a password manager. Keep recovery codes offline.

The schema permits anonymous reads only when `status = 'completed'`. A second policy permits the designated owner UUID to read all records. Insert, edit, and delete policies require that same UUID; clients cannot choose a different owner ID. Public signup is disabled as an additional control.

## Free GitHub Pages address

This project includes a GitHub Actions workflow that builds and deploys the site whenever you update the `main` branch. GitHub Pages is free for public repositories; the published website and its repository source are public. For the shortest address, create a public repository named exactly `<your-github-username>.github.io`. GitHub will publish it at `https://<your-github-username>.github.io/`. Alternatively, use a repository named `arryan-rana-portfolio`, which publishes at `https://<your-github-username>.github.io/arryan-rana-portfolio/`.

Beginner steps are in `GITHUB-SETUP.txt`. In the repository, open **Settings → Pages** and choose **GitHub Actions** as the build and deployment source. The included workflow publishes the `dist` folder. If you use Supabase, add `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` under **Settings → Secrets and variables → Actions**. The publishable/anon key is meant for browser use; never add a service-role key. The site URL is free; a custom domain such as `.com` is usually purchased separately.

## Deploy online with Vercel

1. Create a private GitHub repository, put this folder in it, and push the code.
2. Import the repository in Vercel. Use the Vite preset; the build command is `pnpm build` and output directory is `dist`.
3. In Vercel project settings, add `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` for Preview and Production, then redeploy.
4. Add your domain in Vercel and configure the DNS records it provides.
5. Add the production domain to Supabase Authentication's allowed site and redirect URLs. Remove temporary or unused origins.
6. Visit `https://your-domain/#/admin`, sign in, and add projects. Set a project to **Completed · public** only when it is ready to share. **In progress · private** records remain private and do not appear in the public gallery.

You can deploy the Vite build to other static hosts too. Keep SPA fallback/rewrite behavior enabled so `/#/admin` resolves to `index.html` (the supplied admin route uses a URL hash).

## Authentication and session notes

The client uses Supabase Auth password sign-in with PKCE, automatic token refresh, and persistent sessions. Use HTTPS only in production and configure the exact allowed origins. Sessions are stored by the Supabase browser SDK in browser storage, so protect the app against script injection: keep dependencies updated, avoid untrusted HTML, and add a Content Security Policy at the host that allows only this site's scripts plus the exact Supabase API and Google Fonts origins you use. The UI escapes database text before inserting it into HTML, and links are restricted to HTTP(S).

For a higher-assurance setup, put the admin behind a server-rendered backend-for-frontend that stores sessions in Secure, HttpOnly, SameSite cookies, and require MFA for owner sign-in. Do not treat hiding the admin link as access control: Supabase Auth plus RLS are the access controls here. Review the RLS policies after changing the schema. The owner UUID is intentionally a manual one-time configuration value.

## Included files

- `src/config.js`: personal brand settings
- `src/main.js`: public gallery and owner CRUD interface
- `src/style.css`: responsive construction-site inspired visual style
- `supabase/schema.sql`: table and row-level security policies
- `.env.example`: public Supabase connection settings template

