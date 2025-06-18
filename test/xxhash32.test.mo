/*******************************************************************
* Copyright         : 2025 nirvana369
* File Name         : lib.test.mo
* Description       : test
*                    
* Revision History  :
* Date				Author    		Comments
* ---------------------------------------------------------------------------
* 18/06/2025		nirvana369 		implement
******************************************************************/

import {hash; xxhash} "../src/lib";
import {test; suite} "mo:test";
import Blob "mo:base/Blob";
import Array "mo:base/Array";
import Nat8 "mo:base/Nat8";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Text "mo:base/Text";


actor {

    public func runTests() : async () {

        let testCases = [
            {
                input = #blob (Blob.fromArray([]));
                seed = 0;
                expected = "2cc5d05";
            },
            {
                input = #blob (Blob.fromArray([97])); // "a"
                seed = 0;
                expected = "550d7456";
            },
            {
                input = #text "ab"; // "ab"
                seed = 0;
                expected = "4999fc53";
            },
            {
                input = #text "abc"; // "abc"
                seed = 0;
                expected = "32d153ff";
            },
            {
                input = #blob (Blob.fromArray([97, 98, 99, 100])); // "abcd"
                seed = 0;
                expected = "a3643705";
            },
            {
                input = #text "abcde"; // "abcde"
                seed = 0;
                expected = "9738f19b";
            },
            {
                input = #text (Text.join("", Array.tabulate<Text>(10, func _ = "ab").vals())); // "ab" x 10
                seed = 0;
                expected = "244fbf7c";
            },
            {
                input = #text (Text.join("", Array.tabulate<Text>(100, func _ = "abc").vals())); // "ab" x 10
                seed = 0;
                expected = "55cad6be";
            },
            {
                input = #text "My text to hash 😊"; // "ab"
                seed = 0;
                expected = "af7fd356";
            },
            {
                input = #blob (Blob.fromArray([0])); // single 0x00
                seed = 0;
                expected = "cf65b03e";
            },
            {
                input = #blob (Blob.fromArray([255])); // single 0xFF
                seed = 0;
                expected = "96bcd8cc";
            },
            {
                input = #blob (Blob.fromArray([0, 0, 0, 0])); // four 0x00 bytes
                seed = 0;
                expected = "8d6d969";
            },
            {
                input = #blob (Blob.fromArray([255, 255, 255, 255])); // four 0xFF bytes
                seed = 0;
                expected = "4079e5f";
            },
            {
                input = #blob (Blob.fromArray(Array.tabulate<Nat8>(127, func i = 97))); // "a" * 127
                seed = 0;
                expected = "88e84102";
            },
            {
                input = #blob (Blob.fromArray(Array.tabulate<Nat8>(128, func i = 97))); // "a" * 128
                seed = 0;
                expected = "84a92d6";
            },
            {
                input = #blob (Blob.fromArray(Array.tabulate<Nat8>(129, func i = 97))); // "a" * 129
                seed = 0;
                expected = "f46cb281";
            },
            {
                input = #blob (Blob.fromArray(Array.tabulate<Nat8>(256, func i = Nat8.fromNat(i)))); // range from [0..255]
                seed = 0;
                expected = "59441253";
            },
            {
                input = #blob (Blob.fromArray(Array.tabulate<Nat8>(256, func i = Nat8.fromNat(255 - i)))); // range from [255..0]
                seed = 0;
                expected = "ae816c35";
            },
            {
                input = #blob (Blob.fromArray([0, 1, 2, 3, 4, 5, 6, 7])); // increasing pattern
                seed = 0;
                expected = "a3ad90b9";
            },
            {
                input = #blob (Blob.fromArray([7, 6, 5, 4, 3, 2, 1, 0])); // decreasing pattern
                seed = 0;
                expected = "8af3058e";
            },
            {
                input = #blob (Blob.fromArray([0, 255, 0, 255, 0, 255, 0, 255])); // alternating pattern
                seed = 0;
                expected = "6d94a8d9";
            },
            {
                input = #blob (Blob.fromArray(Array.tabulate<Nat8>(33, func i = if (i == 32) 66 else 65))); // "A" * 32 + "B"
                seed = 0;
                expected = "a38ca4f";
            },
            {
                input = #blob (Blob.fromArray(Array.tabulate<Nat8>(33, func i = if (i == 0) 66 else 65))); // "B" + "A" * 32
                seed = 0;
                expected = "696f8a3c";
            },
            {
                input = #blob (Blob.fromArray(
                    Array.append<Nat8>(
                        Array.tabulate<Nat8>(15, func i = 65),
                        Array.append<Nat8>([66], Array.tabulate<Nat8>(16, func i = 65))
                    )
                ));
                seed = 0;
                expected = "13674c01";
            },
            {
                input = #blob (Blob.fromArray(Array.tabulate<Nat8>(1024, func i = 1))); // 1024 bytes of 0x01
                seed = 0;
                expected = "ebf7d486";
            },
            {
                input = #blob (Blob.fromArray(Array.tabulate<Nat8>(4096, func i = Nat8.fromNat(i % 256)))); // 0..4095 mod 256
                seed = 0;
                expected = "693c0bc2";
            }
        ];

        suite("xxhash", func() {

            test("test-case", func() {
                for (x in testCases.vals()) {
                    let output = hash(x.input, x.seed);
                    let hexOutput = xxhash(x.input, x.seed);
                    assert(hexOutput == x.expected);
                };
            });

            test("test-func", func() {
                let textInput : Text = "nirvana369";
                let bytesInput : [Nat8] = [1, 11, 111, 222];
                let blobInput : Blob = Blob.fromArray([110, 105, 114, 118, 97, 110, 97, 51, 54, 57]);
                let seed : Nat = 0;

                let hexOutput : Text = xxhash(#blob blobInput, seed);
                let hexOutput1 : Text = xxhash(#text textInput, seed);

                let output : Nat = hash(#bytes bytesInput, seed);
                assert(hexOutput == hexOutput1);
                assert(output == 3557231637)
            });

        });

        suite("with small input multiple of 4", func() {
            let input = "abcd";
            let expected = "A3643705";
            let seed = 0;

            test("should return hash in a single step", func() {
                let h = Text.toUppercase(xxhash(#text input, seed));
                assert(h == expected);
            });
        });

        suite("with medium input multiple of 4", func() {
            let input = Text.join("",Array.tabulate<Text>(1000, func _ = "abcd").vals()); // 1000 to match JS Array(1000).join
            let expected = "E18CBEA";
            let seed = 0;

            test("should return hash in a single step", func() {
                let h = Text.toUppercase(xxhash(#text input, seed));
                assert(h == expected);
            });
        });

        suite("with small input", func() {
            let input = "abc";
            let expected = "32D153FF";
            let seed = 0;

            test("should return hash in a single step", func() {
                let h = Text.toUppercase(xxhash(#text input, seed));
                assert(h == expected);
            });
        });

        suite("with medium input", func() {
            let input = Text.join("", Array.tabulate<Text>(999, func _ = "abc" ).vals()); // 999 to match JS Array(1000).join
            let expected = "89DA9B6E";
            let seed = 0;

            test("should return hash in a single step", func() {
                let h = Text.toUppercase(xxhash(#text input, seed));
                assert(h == expected);
            });
        });

        suite("with utf-8 strings - heiå", func() {
            let input = "heiå";
            let expected = "DB5ABCCC";
            let seed = 0;

            test("should return hash", func() {
                let h = Text.toUppercase(xxhash(#text input, seed));
                assert(h == expected);
            });
        });

        suite("with utf-8 strings - κόσμε", func() {
            let input = "κόσμε";
            let expected = "D855F606";
            let seed = 0;

            test("should return hash", func() {
                let h = Text.toUppercase(xxhash(#text input, seed));
                assert(h == expected);
            });
        });

    };
}