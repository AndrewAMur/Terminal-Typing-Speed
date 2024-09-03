# Terminal Typing Speed

A simple typing speed test script for the terminal that allows you to customize various settings for your typing practice.

## Getting Started

### Cloning the Repository

First, clone the repository to your local machine:

```bash
git clone https://github.com/AndrewAMur/Terminal-Typing-Speed.git
```

### Making the Script Executable

Navigate to the project directory and make the script executable:

```bash
cd Terminal-Typing-Speed
chmod +x typing_test.sh
```

### Running the Script

You can now run the script with:

```bash
./typing_test.sh
```

## Customizing Your Typing Test

You can customize the typing test using the following options:

### Allow Mistakes and Overwrite Text

To allow mistakes and overwrite text during the test, use:

```bash
./typing_test.sh -m 1
```

### Disable the Timer

To disable the timer and make the test untimed, use:

```bash
./typing_test.sh -t 0
```

### Set a Custom Number of Words

To specify a custom number of words for the test, use:

```bash
./typing_test.sh -n {number of words}
```

#### Example

To set the test to use 30 words instead of the default 10, run:

```bash
./typing_test.sh -n 30
```

## Contributing

If you would like to contribute to this project, please follow these steps:

1. Fork the repository on GitHub.
2. Create a new branch for your changes.
3. Commit your changes and push them to your fork.
4. Open a pull request on the original repository.

## Sources

**Wordlist**: [Treegle May 5664-word list](https://github.com/MichaelWehar/Public-Domain-Word-Lists/blob/master/5664-freq-treegle-may.txt)
