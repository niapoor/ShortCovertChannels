# Tmp Covert Channel
A short covert channel that utilizes temporary modulations to file permissions and hard link count. Created by Nia Poor.

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#How-It-Works">How It Works</a></li>
    <li><a href="#Instructions">Instructions</a></li>
    <li><a href="#Limitations">Limitations</a></li>
  </ol>
</details>

## How It Works

This covert channel takes in a secret message from the user, converting it to binary. Each ASCII character is represented by 8 bits of binary.

To convey the secret, this channel uses the permissions of a temporary file. Since a file has 9 bits used for permissions (e.g., rwxrwxrwx), and each ASCII character needs only 8 bits to represent itself, we always ignore the owner's write permissions. This ensures we never face issues when changing the permissions of or deleting the file.

When assigning permissions to represent the covert message, we consider `r/w/x` as a `1` and `-` as a `0`. For example, the ASCII character `a` is represented as `01100001`, and its corresponding permissions would be `-wxr----x` (keeping in mind that the first 'w', representing the owner's write permission, remains unaffected and always true).

Each time 'send.sh' updates the tmp file's permissions, it adds another hard link to the file. This is so 'receive.sh' knows to read the file's permissions again. This ensures 'receive.sh' properly accounts for duplicate characters in a message (e.g., the two 'o's in the word 'pool')."

<p align="right">(<a href="#top">back to top</a>)</p>






## Instructions

### recieve.sh
* Run in a Linux termial.
* Keep running until and while running send.sh. It will stop automatically once it has read a message and printed it to the terminal.

### send.sh
* Run in the same directory as recieve.sh
* Run in a Linux terminal with the covert message as an argument (e.g., `bash send.sh "This is a secret, shhh"`).
* If send.sh does not run in full, it will fail to delete the tmp directory and its contents. To do so, run the command `rm -rf tmp`.

<p align="right">(<a href="#top">back to top</a>)</p>






## Limitations

Covert channels are notoriously fragile. Here are some notable limitations of this one:

* Logs would retain artifacts of the channel.
* recieve.sh must already be running when send.sh begins in order to capture the entire message.
* Both the sender and reciever must run their programs on the same machine in the same directory.
* An outsider cannot change file permissions or add additional hard links while the file is still running.
* Can not take in all special characters (e.g., ! and ?). Can take in "." and ",".

<p align="right">(<a href="#top">back to top</a>)</p>



### Disclaimer
This project was created for educational purposes only. The creator of the covert channels in this repository is not liable for the use or misuse of this project.

<p align="right">(<a href="#top">back to top</a>)</p>
