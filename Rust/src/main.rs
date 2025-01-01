use std::io::{BufReader, Read, Write};
use std::net::{TcpListener, TcpStream};

fn main() {
    let server = TcpListener::bind("127.0.0.1:53982").unwrap();

    println!("TCP Running on {}", server.local_addr().unwrap());

    for stream in server.incoming() {
        let mut _stream = stream.unwrap();

        handle_connection(&mut _stream);
    }
}

fn handle_connection(stream: &mut TcpStream) {
    let mut buf_reader = BufReader::new(&*stream);
    let buf: &mut String = &mut String::new();
    _ = buf_reader.read_to_string(buf);

    println!("Request: {:?}", buf);

    stream.write_all(b"Request Received").unwrap();
}
