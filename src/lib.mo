/*******************************************************************
* Copyright         : 2025 nirvana369
* File Name         : lib.mo
* Description       : library interface
*                    
* Revision History  :
* Date				Author    		Comments
* ---------------------------------------------------------------------------
* 18/06/2025		nirvana369 		implement
******************************************************************/

import XXHash "./xxhash32";
import Text "mo:base/Text";
import Blob "mo:base/Blob";
import Nat64 "mo:base/Nat64";


module {

    public type XXHashInput = {
        #text: Text;
        #bytes: [Nat8];
        #blob: Blob;
    };

    public func hash(input: XXHashInput, seed: Nat) : Nat {
        let output = switch (input) {
                        case (#text(text)) {
                            let bytes = Text.encodeUtf8(text);
                            XXHash.hash(Blob.toArray(bytes), Nat64.fromNat(seed));
                        };
                        case (#bytes(bytes)) {
                            XXHash.hash(bytes, Nat64.fromNat(seed));
                        };
                        case (#blob(blob)) {
                            XXHash.hash(Blob.toArray(blob), Nat64.fromNat(seed));
                        };
                    };
        Nat64.toNat(output);    
    };

    public func xxhash(input: XXHashInput, seed: Nat) : Text {
        let hashValue = hash(input, seed);
        nat2Hex(hashValue);
    };

    public func nat2Hex(x : Nat) : Text {
        if (x == 0) return "0";
        var ret = "";
        var t = x;
        while (t > 0) {
            ret := (switch (t % 16) {
                case 0 { "0" };
                case 1 { "1" };
                case 2 { "2" };
                case 3 { "3" };
                case 4 { "4" };
                case 5 { "5" };
                case 6 { "6" };
                case 7 { "7" };
                case 8 { "8" };
                case 9 { "9" };
                case 10 { "a" };
                case 11 { "b" };
                case 12 { "c" };
                case 13 { "d" };
                case 14 { "e" };
                case 15 { "f" };
                case _ { "*" };
            }) # ret;
            t /= 16;
        };
        ret
    };
}