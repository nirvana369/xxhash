/*******************************************************************
* Copyright         : 2025 nirvana369
* File Name         : xxhash32.mo
* Description       : xxhash 32-bit
*                    
* Revision History  :
* Date				Author    		Comments
* ---------------------------------------------------------------------------
* 17/06/2025		nirvana369 		implement
******************************************************************/

import Buffer "mo:base/Buffer";
import Nat64 "mo:base/Nat64";
import Nat8 "mo:base/Nat8";
import Int64 "mo:base/Int64";

module {

    let PRIME32_1 : Nat64 = 2654435761;
    let PRIME32_2 : Nat64 = 2246822519;
    let PRIME32_3 : Nat64 = 3266489917;
    let PRIME32_4 : Nat64 = 668265263;
    let PRIME32_5 : Nat64 = 374761393;
    /**
    *
    * @param input - byte array
    * @param seed - optional seed (32-bit unsigned);
    */
    public func hash(input: [Nat8], seed: Nat64) : Nat64 {
        let b = input;

        var acc : Nat64 = (seed + PRIME32_5) & 0xffffffff;
        var offset : Nat64 = 0;

        if (b.size() >= 16) {
            let accN = Buffer.Buffer<Nat64>(4);
            accN.add((seed + PRIME32_1 + PRIME32_2) & 0xffffffff);
            accN.add((seed + PRIME32_2) & 0xffffffff);
            accN.add((seed + 0) & 0xffffffff);
            accN.add(Int64.toNat64((Int64.fromNat64(seed) - Int64.fromNat64(PRIME32_1)) & 0xffffffff));

            let limit = Nat64.fromNat(b.size() - 16);
            var lane : Nat64 = 0;
            while ((offset & 0xfffffff0) <= limit) {
                let i = Nat64.toNat(offset);
                let laneN0 : Nat64 = nat8ToNat64(b[i]) | (nat8ToNat64(b[i + 1]) << 8);
                let laneN1 : Nat64 = nat8ToNat64(b[i + 2]) | (nat8ToNat64(b[i + 3]) << 8);
                let laneNP = (laneN0 * PRIME32_2 + ((laneN1 * PRIME32_2) << 16));// & 0xffffffff;
                
                var acc = (accN.get(Nat64.toNat(lane)) + laneNP) & 0xffffffff;
                acc := ((acc << 13) | (acc >> 19)) & 0xffffffff;
                let acc0 : Nat64 = acc & 0xffff;
                let acc1 : Nat64 = (acc >> 16) & 0xffff;
                acc :=  (acc0 * PRIME32_1 + ((acc1 * PRIME32_1) << 16)) & 0xffffffff;
                accN.put(Nat64.toNat(lane), acc);
                
                lane := (lane + 1) & 0x3; // Chỉ sử dụng 4 lane
                offset += 4;
            };

            acc := (
                (((accN.get(0) << 1) | (accN.get(0) >> 31)) & 0xffffffff) +
                (((accN.get(1) << 7) | (accN.get(1) >> 25)) & 0xffffffff) +
                (((accN.get(2) << 12) | (accN.get(2) >> 20)) & 0xffffffff) +
                (((accN.get(3) << 18) | (accN.get(3) >> 14)) & 0xffffffff)
            ) & 0xffffffff;
        };

        // Thêm độ dài input vào accumulator
        acc := (acc + Nat64.fromNat(b.size())) & 0xffffffff;

        // Xử lý các byte còn lại (từng khối 4 byte)
        if (b.size() >= 4) {
            let limit = Nat64.fromNat(b.size() - 4);
            while (offset <= limit) {
                let i = Nat64.toNat(offset);
                let laneN0 : Nat64 = nat8ToNat64(b[i]) | (nat8ToNat64(b[i + 1]) << 8);
                let laneN1 : Nat64 = nat8ToNat64(b[i + 2]) | (nat8ToNat64(b[i + 3]) << 8);
                let laneP = laneN0 * PRIME32_3 + ((laneN1 * PRIME32_3) << 16);// & 0xffffffff;
                
                acc := (acc + laneP) & 0xffffffff;
                acc := ((acc << 17) | (acc >> 15)) & 0xffffffff;
                let acc0 : Nat64 = acc & 0xffff;
                let acc1 : Nat64 = (acc >> 16) & 0xffff;
                acc := (acc0 * PRIME32_4 + ((acc1 * PRIME32_4) << 16)) & 0xffffffff;
                offset += 4;
            };
        };

        // Xử lý các byte cuối cùng (<4 byte)
        var i = Nat64.toNat(offset);
        while (i < b.size()) {
            let lane = nat8ToNat64(b[i]) & 0xffffffff;
            acc := (acc + lane * PRIME32_5) & 0xffffffff;
            acc := ((acc << 11) | (acc >> 21)) & 0xffffffff;
            let acc0 : Nat64 = acc & 0xffff;
            let acc1 : Nat64 = (acc >> 16) & 0xffff;
            acc := (acc0 * PRIME32_1 + ((acc1 * PRIME32_1) << 16)) & 0xffffffff;
            i += 1;
        };

        // Avalanche effect (trộn cuối cùng)
        acc := (acc ^ (acc >> 15)) & 0xffffffff;
        acc := ((((acc & 0xffff) * PRIME32_2) & 0xffffffff) + ((((acc >> 16) & 0xffff) * PRIME32_2) << 16)) & 0xffffffff;
        acc := (acc ^ (acc >> 13)) & 0xffffffff;
        acc := ((((acc & 0xffff) * PRIME32_3) & 0xffffffff) + ((((acc >> 16) & 0xffff) * PRIME32_3) << 16)) & 0xffffffff;
        acc := (acc ^ (acc >> 16)) & 0xffffffff;

        return acc;
    };

    private func nat8ToNat64(n : Nat8) : Nat64 {
        return Nat64.fromNat(Nat8.toNat(n));
    };
}