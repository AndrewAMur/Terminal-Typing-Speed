# Instructions

## Downloading the script
```
git clone https://github.com/AndrewAMur/Terminal-Typing-Speed.git
```

## Making the script runnable

```
cd Terminal-Typing-Speed
chmod +x typing_test.sh
```

## Running the script

```
./typing_test.sh
```

# Custom Settings

## Allowing mistakes and overwriting text

```
./typing_test.sh -m 1
```

## Disabling the timer

```
./typing_test.sh -t 0
```

## Having a custom number of words for the test

```
./typing_test.sh -n {number of words}
```

### Example

```
./typing_test.sh -n 30
```

This example has 30 words instead of the default (which is 10)
