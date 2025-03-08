import json
import jax
import jax.numpy as jnp
from flax import nnx
from layers import *


class Reed(nnx.Module):
    """ Reed Model
    input shape: (batch, context_len)
    output shape: (batch, output_len, vocab_size)
    """
    def __init__(self, key, dtype=jnp.float32):
        """ The Reed Model
        input shape: (batch, context_len)
        output shape: (batch, context_len, vocab_size)
        """
        super().__init__()

        with open('./tokenizer/config.json', 'r') as file:
            config = json.load(file)
            vocab_size = int(config['model']['vocab_size'])

        with open('config.json', 'r') as file:
            config = json.load(file)
            config = config['model']

            feature = int(config['Feature'])
            attn_feature = int(config['ATTN Feature'])
            ffn_feature = int(config['FFN Feature'])
            num_head = int(config['Head Count'])
            group_size = int(config['Group Size'])
            decoder_count = int(config['Decoder Count'])
            random_scalar = float(config['Random Scalar'])

        keys = jax.random.split(key, num=decoder_count + 2)

        self.embed = Featurize(vocab_size=vocab_size, feature=feature, key=keys[-1], dtype=dtype)
        self.norm = RMSNorm(feature=feature, dtype=dtype)
        self.linear = nnx.Linear(in_features=feature, out_features=vocab_size, rngs=nnx.rnglib.Rngs(keys[-2]), dtype=dtype, param_dtype=dtype)
        self.decoders = [
            GroupedQueryDecoder(
                feature=feature,
                attn_feature=attn_feature,
                ffn_feature=ffn_feature,
                num_head=num_head,
                group_size=group_size,
                random_scalar=random_scalar,
                key=keys[i],
                dtype=dtype
            ) for i in range(decoder_count)
        ]
        # self.decoders = [
        #     MultiHeadDecoder(
        #         feature=feature,
        #         attn_feature=attn_feature,
        #         ffn_feature=ffn_feature,
        #         num_head=num_head,
        #         random_scalar=random_scalar,
        #         key=keys[i],
        #         dtype=dtype
        #     ) for i in range(decoder_count)
        # ]

    def __call__(self, x):
        x = self.embed(x)

        for decoder_instance in self.decoders:
            x = decoder_instance(x)

        x = self.norm(x)
        return self.linear(x)
