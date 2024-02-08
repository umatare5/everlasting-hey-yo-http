package main

import (
	"fmt"
	"math/rand"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"
)

var (
	defaultPort  = "8080"
	defaultMsg   = "Hey, Yo!"
	anotherMsg   = "Check It Out! Yo!"
	httpRespBody = "Yo!"
)

// output is a function that prints a message to the console.
func output(msg string) {
	fmt.Println(msg)
}

// startBackgroundProcess is a function that starts a background process that runs forever.
func startBackgroundProcess() {
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, syscall.SIGTERM)

	go func() {
		for {
			select {
			case <-sigChan:
				output("Hey, Hey, " + defaultMsg + "!!")
			}
		}
	}()

	go func() {
		for {
			msg := defaultMsg

			if os.Getenv("GIVE_ME_PATTERN") != "" && rand.Intn(2) == 1 {
				msg = anotherMsg
			}

			if os.Getenv("BE_QUIET") == "" {
				output(msg)
			}

			time.Sleep(1 * time.Second)
		}
	}()
}

// httpHandler is a simple HTTP handler that returns a 200 status code and a message 'Yo!'.
func httpHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, httpRespBody)
}

func main() {
	startBackgroundProcess()

	http.HandleFunc("/", httpHandler)

	port := os.Getenv("PORT")
	if port == "" {
		port = defaultPort
	}

	fmt.Printf("Starting HTTP server on port %s\n", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		fmt.Printf("Error starting server: %s\n", err)
	}
}
