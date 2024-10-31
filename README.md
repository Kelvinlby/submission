<div align="center">
  <img src="icon.png" alt="Logo" width="128" height="128">
<h3 align="center">Submission</h3>
<p>ML dashboard for any framework.</p>
</div>

<br>

## Key Features
- One click training for all frameworks
- Convenient parameter control
- Neat system resource monitoring and training result ploting
- Preallocation control for `XLA`: Full / On-demand allocation

> To enable `XLA` preallocation control feature, use `-xla` flag or `submission-xla.desktop`

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

### Setup Python Client
- Install python package
```shell
conda install xxx
```
- Import
```python
from submission_client import submission
```

### Log Your Data
#### Metric Logging
- Log a metric
```python
submission.log_metric('METRIC_NAME')
```

#### Job Logging
- Start a job without progress tracking
```python
submission.start_job('JOB_NAME')
```
> You can enable progress tracking later by calling `submission.log_job('JOB_NAME', NUM_VALUE)`

- Start a job with progress tracking
```python
submission.log_job('JOB_NAME', NUM_VALUE)
```
> You don't need to start a job before logging. New job will be created automantically when being logged for the first time.

- End a job
```python
submission.end_job('JOB_NAME')
```
