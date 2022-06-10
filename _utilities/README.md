reset_docker_iptables.sh

Sometimes you will get an error during the RKE install similar to this "iptables: No chain/target/match by that name." This occurs when Docker doesn't fully flush IPTables rules. This script clears all IPTables rules and restarts the docker service. The next RKE install run should work after this.