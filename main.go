package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"strconv"
	"strings"
)

func main() {
	http.HandleFunc("/status", serveStatus)
	http.HandleFunc("/health-check", serveStatus)
	http.HandleFunc("/", serveError)

	port := os.Getenv("PORT")
	if port == "" {
		port = "5000"
	}
	fmt.Printf("listening on %v...\n", port)
	err := http.ListenAndServe(":"+port, nil)
	if err != nil {
		panic(err)
	}
}

func serveStatus(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	body := "OK"
	w.Header().Set("Content-Length", fmt.Sprint(strconv.Itoa(len(body))))
	w.WriteHeader(200)
	w.Write([]byte(body))
}

func serveError(w http.ResponseWriter, r *http.Request) {
	responseCode := os.Getenv("CODE")
	// Por defecto se retorna 404.
	if responseCode == "" {
		responseCode = "404"
	}

	code, _ := strconv.Atoi(responseCode)

	acceptType := r.Header.Get("Accept")
	contentType := r.Header.Get("Content-Type")

	extension := "html"
	w.Header().Set("Content-Type", "text/html; charset=utf-8")

	if strings.Contains(contentType, "application/json") || strings.Contains(acceptType, "application/json") {
		w.Header().Set("Content-Type", "application/json")
		extension = "json"
	}

	body, _ := ioutil.ReadFile("./errors/" + responseCode + "." + extension)
	w.Header().Set("Content-Length", fmt.Sprint(strconv.Itoa(len(body))))
	w.WriteHeader(code)
	w.Write(body)
}
