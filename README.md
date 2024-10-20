<div align="center">
  <img src="icon.png" alt="Logo" width="128" height="128">
<h3 align="center">Submission</h3>
<p>ML dashboard for any framework.</p>
</div>

<br>

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

- Install Python client package

```shell
conda install xxxx
```

