[![mops](https://oknww-riaaa-aaaam-qaf6a-cai.raw.ic0.app/badge/mops/xxhash)](https://mops.one/xxhash) [![documentation](https://oknww-riaaa-aaaam-qaf6a-cai.raw.ic0.app/badge/documentation/xxhash)](https://mops.one/xxhash/docs)
# xxhash
### An implementation of the 32-bit XXHash algorithm in Motoko

## Documentation
* [Installation](###installation)
* [Usage](#usage)
* [Testing](#testing)
* [Benchmarks](#benchmarks)
* [License](#license)

### Installation

Install with mops

You need mops installed. In your project directory run [Mops](https://mops.one/):

```sh
mops add xxhash
```

### Usage

```sh
import {hash; xxhash} "mo:xxhash";

let textInput : Text = "nirvana369";
let bytesInput : [Nat8] = [1, 11, 111, 222];
let blobInput : Blob = Blob.fromArray([110, 105, 114, 118, 97, 110, 97, 51, 54, 57]);
let seed : Nat = 0;

let hexOutput : Text = xxhash(#blob blobInput, seed);
let hexOutput1 : Text = xxhash(#text textInput, seed);

let output : Nat = hash(#bytes bytesInput, seed);
```


### Testing

You need mops installed. In your project directory run [Mops](https://mops.one/):

```sh
mops test
```

### Benchmarks

You need mops installed. In your project directory run [Mops](https://mops.one/):

```sh
mops bench
```
				
XXHash module benchmark
				

Instructions

|             |          1 |          10 |           100 |           500 |           1000 |
| :---------- | ---------: | ----------: | ------------: | ------------: | -------------: |
| xxhash-1kb  |      1_595 |       1_843 |         2_091 |         2_091 |          2_339 |
| xxhash-10kb | 13_232_110 | 132_272_679 | 1_322_446_241 | 6_613_799_781 | 13_226_153_874 |
				

Heap

|             |     1 |    10 |   100 |   500 |  1000 |
| :---------- | ----: | ----: | ----: | ----: | ----: |
| xxhash-1kb  | 272 B | 272 B | 272 B | 272 B | 272 B |
| xxhash-10kb | 272 B | 272 B | 308 B | 308 B | 308 B |
				

Garbage Collection

|             |          1 |       10 |       100 |        500 |       1000 |
| :---------- | ---------: | -------: | --------: | ---------: | ---------: |
| xxhash-1kb  |      396 B |    396 B |     396 B |      396 B |      396 B |
| xxhash-10kb | 495.93 KiB | 4.84 MiB | 48.38 MiB | 241.98 MiB | 483.94 MiB |

## License
[MIT](https://github.com/nirvana369/xxhash/blob/main/LICENSE)
