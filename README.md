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

> To enable `XLA` preallocation control feature, add `-xla` flag.

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
conda install submission
```
- Import
```python
import asyncio
from submission import start_job, log_job, log_metric, end_job
```

### Log Your Data
#### Metric Logging
- Log a metric
```python
asyncio.run(submission.log_metric('METRIC_NAME', NUM_VALUE))
```

#### Job Logging
- Start a job without progress tracking
```python
asyncio.run(submission.start_job('JOB_NAME'))
```
> You can enable progress tracking later by calling `submission.log_job('JOB_NAME', NUM_VALUE)`

- Start a job with progress tracking
```python
asyncio.run(submission.log_job('JOB_NAME', NUM_VALUE))
```
> You don't need to start a job before logging. New job will be created automantically when being logged for the first time.

- End a job
```python
asyncio.run(submission.end_job('JOB_NAME'))
```
