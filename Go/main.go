package main

import (
	"bufio"
	"fmt"
	"io"
	"log"
	"net"
)

func main() {
	listen, err := net.Listen("tcp", ":53982")
	if err != nil {
		log.Fatal(err)
	}
	defer listen.Close()

	fmt.Printf("Listening on %s", listen.Addr().String())

	for {
		stream, err := listen.Accept()
		if err != nil {
			fmt.Println(err)
			return
		}

		go handle_connection(stream)
	}
}

func handle_connection(stream net.Conn) {
	reader := bufio.NewReader(stream)

	defer stream.Close()

	message, err := io.ReadAll(reader)
	if err != io.EOF {
		fmt.Println(err)
	}

	fmt.Printf("Message: %s", string(message))

	stream.Write([]byte("Hello"))
}
