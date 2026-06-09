## Settings Screen Explained

### Burst count

- This is how many photos the app takes in one burst command.
- Example: `5` means one burst will capture 5 images back-to-back.
- If you want more pictures between camera switches, raise this value.
- If you want fewer files and less storage use, lower it.

### Capture interval seconds

- This is the delay between capture actions.
- If the app is running in an automatic loop, it waits this many seconds between each capture or burst.
- To extend time between captures, increase this number.
- To capture more frequently, decrease it.

### Camera switching interval seconds

- This controls how long the service stays on one camera before switching to the next camera.
- A low value means faster switching between front/back or selected cameras.
- To get more images on the same camera before it switches, increase this value.
- If you want the service to stay on a camera longer, make this interval larger.

### Auto camera selection

- When enabled, the app automatically chooses the best available camera.
- It can avoid a camera that appears blocked or too dark.
- When disabled, the service will stick to the current camera unless you explicitly command a switch.
- Use this if you want manual control over which camera is used, or if automatic blocking detection is too aggressive.

## How to get more images between camera switches

- Increase `Burst count` so each capture event produces more images.
- Increase `Camera switching interval seconds` so the camera stays longer before changing.
- Optional: decrease `Capture interval seconds` if you want more bursts in the same period, but that increases total image rate.

## How to extend time between captures

- Increase `Capture interval seconds` to wait longer between each capture/burst.
- Lower `Burst count` if you want fewer images per event, though that does not change the time delay itself.
- If the app is switching cameras too often, also increase `Camera switching interval seconds`.

## Practical combinations

- More images on one camera: `Burst count` up, `Camera switching interval seconds` up.
- Slower overall capture pace: `Capture interval seconds` up.
- More frequent capture but still longer on each camera: lower `Capture interval seconds` and raise `Camera switching interval seconds`.

If you want a specific result, I can suggest exact values for your use case.
