<div align="center">
  <img src="icon.png" alt="Logo" width="128" height="128">
<h3 align="center">Submission</h3>
<p>ML dashboard for any framework.</p>
</div>

<br>

## Key Features
- One click training for all frameworks
- Convenient parameter control
- Neat system resource monitoring
- Preallocation control for `XLA`: Full / On-demand allocation

> To enable `XLA` preallocation control feature, add `-xla` flag.

## Getting Started
### Installation
First go to [Release](https://github.com/Kelvinlby/submission/releases/latest) page and download the lates version of `Submission`.

### Configuring Adjustable Parameters
Create a `json` file to store all the parameters you'd like Submission to adjust and select it in `Config` field in the left panel. The `json` file must be formatted in the following way (you can have any valid json name you want, the following is just an example):

```json5
{
  "setting-group-1": {
    "item-1": 9894,
    "item-2": 4096,
    ...
  },
  "setting-group-2": {
    "item-1": 0.001,
    ...
  },
  ...
}
```

### Configuring Python Interpreter

- For system-installed python, simply find it with `which python`
- For conda users, you need to guarantee there is python in the environment. You should select the python in the environment instead of the python of base conda as the interpreter.
- For UV users, select `YOUR_PROJECT/.venv/bin/python`
