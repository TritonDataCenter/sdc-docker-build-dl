package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"time"

	"github.com/docker/docker/pkg/jsonmessage"
	"github.com/christophwitzko/go-curl"
)

var filename string
var uid int64
var gid int64


func downloadUrl(url string) error {
	err, _ := curl.File(
		url,
		filename,
		func(st curl.IoCopyStat) error {
			message := jsonmessage.JSONMessage { Status: "Downloading", Progress: &jsonmessage.JSONProgress{ Current: st.Size, Total: st.Length } }
			message.ProgressMessage = message.Progress.String()
			data, _ := json.Marshal(message)
			fmt.Println(string(data))
			return nil
		},
		"cbinterval=", 0.5,           // Run callback every 0.5 second
		"dialtimeout=", time.Minute,  // One minute dial timeout
		"followredirects=", true,
		"readtimeout=", time.Hour,    // One hour read timeout
	)
	return err
}

func init() {
    flag.Usage = func() {
        fmt.Printf("Usage: %s [-f filename] [-u uid] [-g gid] URL\n", os.Args[0])
        flag.PrintDefaults()
    }
	flag.StringVar(&filename, "f", "", "the full path of the saved file")
	flag.Int64Var(&uid, "u", 0, "the user id for the saved filename")
	flag.Int64Var(&gid, "g", 0, "the group id for the saved filename")
}

func main() {
	flag.Parse()
	if (flag.NArg() != 1) || (filename == "") || (flag.Arg(0) == "") {
		flag.Usage()
		os.Exit(1)
	}

	err := downloadUrl(flag.Arg(0))
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(2)
	}

	os.Exit(0)
}
