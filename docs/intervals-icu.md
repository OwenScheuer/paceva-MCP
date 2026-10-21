# Intervals.icu: how watch data gets into Paceva

Garmin, Coros, Wahoo, Polar and Suunto don't hand data straight to small apps
(Garmin's program is closed to new apps, and the paid middlemen cost about
$400 a month). So Paceva reads through **[Intervals.icu](https://intervals.icu)**,
a free training platform that already syncs with all of them.

**Intervals.icu is a separate company.** When you connect, your watch sends
data to Intervals.icu, which keeps its own copy under its own privacy policy, and Paceva reads from
there.
Paceva says this on the connect screen, not in small print.

## For athletes: connecting, step by step

1. **Make a free Intervals.icu account** at intervals.icu (Google or email).
2. **Link your watch inside Intervals.icu:** Settings → *Connections* →
   Garmin Connect (or Coros, Wahoo, Polar, Suunto). Approve on the watch
   maker's site. Intervals.icu imports your history within a few minutes.
3. **In Paceva, open Connect your watch,** pick your watch, tick the consent
   box and press **Connect with Intervals.icu**.
4. **Approve on Intervals.icu.** Paceva asks for read-only access to
   activities and wellness (`ACTIVITY:READ`, `WELLNESS:READ`), nothing else.
5. You're back on Paceva. The first sync pulls two years of workout summaries
   and the last 12 weeks in full detail; the dashboard works while it runs.

New workouts and overnight readings then arrive by themselves.

**Prefer an API key?** In Intervals.icu go to Settings → *Developer settings*
and copy your personal API key, then paste it on Paceva's Connect page instead
of using the sign-in button. It reads the same data. The key is stored
encrypted (AES-256-GCM) and you can disconnect any time.

## For developers: how the integration works

| | |
|---|---|
| Authorize | `https://intervals.icu/oauth/authorize?client_id&redirect_uri&scope=ACTIVITY:READ,WELLNESS:READ&state` |
| Token | `POST https://intervals.icu/api/oauth/token` (form: `client_id`, `client_secret`, `code`) → `access_token`, `athlete.id` |
| API auth | `Authorization: Bearer <token>`, or for a personal key `Authorization: Basic base64("API_KEY:<key>")` |
| Data read | `/api/v1/athlete/{id}`, `/athlete/{id}/activities`, `/activity/{id}`, `/activity/{id}/streams`, `/athlete/{id}/wellness` |

How Paceva handles it:

- **State is pinned to the browser.** The `state` value lives in an
  httpOnly cookie and must match on the callback, so a connect link pasted to
  someone else can't attach their account to yours.
- **Explicit consent first.** The flow won't start without the consent tick,
  and the link is recorded in an audit log.
- **One Intervals.icu athlete, one Paceva account.** Linking an Intervals.icu
  athlete that's already linked elsewhere is refused.
- **Tokens are encrypted at rest** with a key that never lives in the database.
- **Webhooks are a doorbell.** Intervals.icu's webhook only tells Paceva *who*
  has new data. Paceva checks the shared secret (constant-time compare), then
  fetches the data itself with that athlete's own token. Nothing in the webhook
  body is stored, so a forged call can at most trigger a harmless re-sync.
- **No double counting.** The same ride from a .fit upload, Apple Health and
  Intervals.icu is stored once, keeping the best copy.
- **Device numbers win.** When the watch reports HRV, sleep score, Body
  Battery or VO2 max, Paceva shows the watch's number and labels it `device`.

### Running your own OAuth app (self-hosters and contributors)

Register an app at intervals.icu → Settings → *Developer settings*:

| Field | Value |
|---|---|
| Redirect URL | `https://<your-domain>/api/intervals/callback` (and `http://localhost:3000/api/intervals/callback` for local) |
| Scopes | `ACTIVITY:READ`, `WELLNESS:READ` |
| Webhook URL | `https://<your-domain>/api/intervals/webhook` |
| Webhook secret | `openssl rand -hex 32` |

Until your OAuth app is set up, test with a personal API key: everything
after sign-in works the same.
