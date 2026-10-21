# Tools

Every tool is read-only and works on the signed-in athlete only. Results are JSON in a single text block, shaped as `{ today, data, notice? }`: `today` is the athlete's local date, and `notice` appears (`SAMPLE DATA ...`) when there is no synced data yet.

Errors that the model can recover from (an unknown workout id, a missing argument) come back as a normal tool result with `isError: true` and a sentence explaining what to try.

### `get_today` · Today's readiness

This morning's recovery (or Garmin Body Battery), HRV, resting heart rate, last night's sleep, fitness, fatigue and form, with a one-line read on the day. Use for 'should I train hard today?' and 'am I recovered?'.

No arguments.

### `get_trend` · Wellness trend

Daily values for one wellness metric over a window, for questions like 'is my HRV trending down?' or 'how has my sleep been this month?'.

| Argument | Type | Required | Notes |
|---|---|---|---|
| `metric` | `hrv` \| `resting_hr` \| `sleep` \| `recovery` \| `load` | yes |  |
| `days` | integer | no | Default `28`. |

### `list_workouts` · Recent workouts

The athlete's sessions, newest first, optionally for one sport. Returns ids you can pass to get_workout.

| Argument | Type | Required | Notes |
|---|---|---|---|
| `sport` | `swim` \| `bike` \| `run` | no |  |
| `days` | integer | no | Default `28`. |
| `limit` | integer | no | Default `25`. |

### `get_workout` · One workout

Full summary of a single session by id (from list_workouts).

| Argument | Type | Required | Notes |
|---|---|---|---|
| `id` | string | yes |  |

### `get_sport` · Sport overview

One sport over a window: volume and headline pace/speed against the previous window, best efforts at standard durations, and training zones.

| Argument | Type | Required | Notes |
|---|---|---|---|
| `sport` | `swim` \| `bike` \| `run` | yes |  |
| `days` | integer | no | Default `28`. |

### `get_predictions` · Race predictions

Predicted finish times as ranges for the athlete's goal races, standard single-sport distances, and triathlons (with leg splits). Each range holds about confidencePct of the time and has been checked against the athlete's own history. Always quote the range, not a single time.

No arguments.

### `get_race_plan` · Race plan

Pacing splits and taper for the athlete's main goal race: target time and where it came from, per-split targets, taper steps, and current vs projected race-morning form.

No arguments.

### `get_bike_setup` · Bike setup

The athlete's race bike: type, make and model, accessories, and how much the setup is worth in race time.

No arguments.

