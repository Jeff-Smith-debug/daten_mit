//first demo:hello.bsv
package Hello;	//package name:Hello

	module mkTb();
		rule hello;
			$display("Hello World!");
			$finish;
		endrule
	endmodule

endpackage
