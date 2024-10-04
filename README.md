# Submission

ML dashboard for every framework.

## Getting Started

### Configuring Adjustable Parameters

In order to let Submission connect to your ML project, you need to create a `json` file to store all the parameters you'd like Submission to adjust. The `json` file must contain two keywords: `model` and `train` , in which you should store related parameters. Here is an example:

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

Submission is able to receive the content printed to command line in your python script. To let Submission record data, use `print()` function with the following format to let Submission recognize what you want to record.

| Task                 | Format                       |
| -------------------- | ---------------------------- |
| Start new job        | `[START_JOB]YourJobName`     |
| End the previous job | `[END_JOB]YourJobName`       |
| Add metric           | `[ADD_METRIC]MetricName`     |
| Record data          | `[MetricName]NumberOnlyData` |
