const Resource = artifacts.require("Resource");
module.exports = function (deployer) {
  // Use deployer to state migration tasks.
  deployer.deploy(Resource);
};
