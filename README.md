<div align="center">
  <img src="icon.png" alt="Logo" width="128" height="128">
<h3 align="center">Submission</h3>
<p>ML dashboard for any framework.</p>
</div>

<br>

## Getting Started

### Configuring Adjustable Parameters

In order to adjust parameters directly in `Submission` , you need to create a `json` file to store all the parameters you'd like Submission to adjust and select it in `Config` field in the left panel. The `json` file must contain two keywords: `model` and `train` , in which you should store related parameters. Here is an example:

```json5
{
  "model": {
    "dict_len": 9894,
    "d_model": 4096
  },
  "train": {
    "learning_rate": 0.001,
    "batch_size": 256
  }
}
```

### Logging Training State

- Install Python client package

```shell
conda install submission-client
```
- Import and initialize
```python
import submission-client as submission
```
- Add a metric to be logged in `Submission`
```python
submission.add_metric('YOUR_METRIC_NAME')
```
- log the value of your metric
```python
submission.log('YOUR_METRIC_NAME', 0.998)
```

