import Vector::*;
import FIFO::*;
//self-define
import Ehr::*;

interface Fifo#(numeric type n, type t);
    method Action enq(t x);
    method Action deq;
    method t first;
    method Bool notEmpty;
    method Bool notFull;
endinterface


// Exercise 1
// fifoTest
module mkFifo(Fifo#(3,t)) provisos (Bits#(t,tSz));
// define your own 3-elements fifo here.
    Vector#(3, Reg#(t)) d;
    d[0] <- mkRegU();
    d[1] <- mkRegU();
    d[2] <- mkRegU();
    Reg#(Bit#(3)) v <- mkReg(0);	//valid,v for inicate the use

    // Enq if there's at least one spot open... so, dc is invalid.
    method Action enq(t x) if (v[2] == 0);//judge left at least element
        $display("enq=%d", v);
	//for storge from 0-->2
        if (v[0] == 0) begin 
            d[0] <= x;
            v[0] <= 1;
        end else if (v[1] == 0) begin
            d[1] <= x;
            v[1] <= 1;
        end else begin 
            d[2] <= x;
            v[2] <= 1;
        end
    endmethod

    // Deq if there's a valid d[0]ta at d[0]
    method Action deq() if (v[0] == 1);
        $display("deq=%d", v);
	//shift from 2-->1-->0
        if (v[2]==1) begin
            d[0] <= d[1];
            d[1] <= d[2];
            v[2] <= 0;
        end else if (v[1] == 1) begin
            d[0] <= d[1];
            v[1] <= 0;
        end else begin
            v[0] <= 0;
        end
    endmethod

    // First if there's a valid data at d[0]
	//always judge the index:0 is ok
    method t first() if (v[0] == 1);
        return d[0];
    endmethod

    // Check if fifo's empty
    method Bool notEmpty();
        return v[0] == 1;
    endmethod

    method Bool notFull();
       return v[2] == 0;
    endmethod
endmodule

//Conflcit Test

//Refermodel:Is golden
module mkCF3Fifo(Fifo#(3,t)) provisos (Bits#(t, tSz));
    FIFO#(t) bsfif <-  mkSizedFIFO(3);
    method Action enq( t x);
        bsfif.enq(x);
    endmethod

    method Action deq();
        bsfif.deq();
    endmethod

    method t first();
        return bsfif.first();
    endmethod

    method Bool notEmpty();
        return True;
    endmethod

    method Bool notFull();
        return True;
    endmethod

endmodule
