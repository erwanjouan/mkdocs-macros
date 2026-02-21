package main

import (
	"embed"
	"io/fs"
	"log"
	"net/http"
	"os"
	"os/exec"
	"bufio"
	"fmt"
)

//go:embed all:site
var siteFiles embed.FS

func check_password(){
    reader := bufio.NewReader(os.Stdin)
    fmt.Print("Mot de passe:")
    fmt.Println("\033[8m") // Hide input
    text, _ := reader.ReadString('\n')
    fmt.Println("\033[28m") // Show input
	password, present := os.LookupEnv("MKDOCS_PASSWORD")
    if !present {
        fmt.Print("MKDOCS_PASSWORD environment variable not set.")
        os.Exit(1)
    }
    if text != password + "\n" {
        fmt.Print("Mot de passe erroné")
        os.Exit(1)
    }
}

func main() {

    check_password()

	cmd := exec.Command("/usr/bin/open", "-a", "/Applications/Google Chrome.app", "http://localhost:8080")
	cmd.Run()

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	// Create a sub-filesystem that serves files from the "site" directory.
	subFS, err := fs.Sub(siteFiles, "site")
	if err != nil {
		log.Fatal(err)
	}

	fs := http.FileServer(http.FS(subFS))
	http.Handle("/", fs)

	log.Printf("Serving embedded ./site on HTTP port: %s\n", port)
	err = http.ListenAndServe(":"+port, nil)
	if err != nil {
		log.Fatal(err)
	}
}