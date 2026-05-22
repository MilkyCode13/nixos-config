{...}: {
  sops = {
    defaultSopsFile = ./.sops.yaml;
    # Don't mix sshKeyPaths and keyFile
    age.sshKeyPaths = [];
    age.keyFile = "/persistent/sops/age/keys.txt";

    secrets = {
      "password_hash" = {
        sopsFile = ./secrets/password-hash.yaml;
        owner = "root";
        group = "root";
        mode = "0400";
        neededForUsers = true;
      };
      "deploy_key" = {
        sopsFile = ./secrets/deploy-key.yaml;
        key = "deploy_key_ed25519";
        owner = "root";
        group = "root";
        mode = "0400";
      };
    };
  };
}
