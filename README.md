# galileo442 Runners provider

Contributes two Ubuntu machines to the Runners fleet. Fleet Provider maintains `MACHINE_COUNT=2` and rotates temporary hosts.

Workflows use the shared agent from [hetp4401/runner](https://github.com/hetp4401/runner). The fleet join token is stored only in the encrypted `JOIN_TOKEN` Actions secret.
