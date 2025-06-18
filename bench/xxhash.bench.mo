/*******************************************************************
* Copyright         : 2025 nirvana369
* File Name         : xxhash.bench.mo
* Description       : Benchmark xxhash32.
*                    
* Revision History  :
* Date				Author    		Comments
* ---------------------------------------------------------------------------
* 18/06/2025		nirvana369 		Add benchmarks.
******************************************************************/

import Bench "mo:bench";
import Nat "mo:base/Nat";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Nat8 "mo:base/Nat8";
import Array "mo:base/Array";
import {hash; xxhash} "../src/lib";


module {

    func genBytes(i : Nat, arr : [Nat8]) : [Nat8] {
        Array.flatten<Nat8>(
            Array.tabulate<[Nat8]>(i, func _ = arr)
        );
    };

    func bytes() : [Nat8] {
        let MAX_LENGTH = 1024;
        let big = Buffer.Buffer<Nat8>(MAX_LENGTH);
        for (i in Iter.range(1, MAX_LENGTH)) {
            big.add(Nat8.fromNat(i % 256));
        };
        Buffer.toArray(big);
    };

    public func init() : Bench.Bench {
        let bench = Bench.Bench();

        bench.name("XXHash Benchmark");
        bench.description("XXHash module benchmark");

        bench.rows(["xxhash-1kb",
                    "xxhash-10kb",
                    ]);
        bench.cols(["1", "10", "100", "500", "1000"]);

        let b = bytes();

        bench.runner(func(row, col) {
            let ?n = Nat.fromText(col);

            switch (row) {
                // Engine V1
                case ("xxhash") {
                    for (i in Iter.range(1, n)) {
                        let bytes = genBytes(1, b);
                        ignore xxhash(#bytes bytes, i);
                    };
                };
                case ("xxhash-10kb") {
                    for (i in Iter.range(1, n)) {
                        let bytes = genBytes(10, b);
                        ignore xxhash(#bytes bytes, i);
                    };
                };
                case _ {};
            };
        });

        bench;
  };
};