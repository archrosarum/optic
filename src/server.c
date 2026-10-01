/* server.c
 * This is the access point for clients to make requests to the server process.
 */

#include <arpa/inet.h>
#include <sys/socket.h>
#include <unistd.h>

int main(void)
{
    int server = socket(AF_INET, SOCK_STREAM, 0);

    struct sockaddr_in address = {
        .sin_family = AF_INET,
        .sin_port = htons(8000),
        .sin_addr.s_addr = htonl(INADDR_LOOPBACK)
    };

    bind(server, (struct sockaddr*)&address, sizeof(address));
    listen(server, 5);

    const char response[] =
        "HTTP/1.1 200 OK\r\n"
        "Content-Type: text/plain\r\n"
        "Content-Length: 5\r\n"
        "Connection: close\r\n"
        "\r\n"
        "hello";

    for (;;) {
        int client = accept(server, NULL, NULL);

        char request[4096];
        recv(client, request, sizeof(request), 0);
        send(client, response, sizeof(response) - 1, 0);

        close(client);
    }
}