// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

// const JAN_1ST_2030 = 1893456000;
const amount = 1_000_000_00000000000000000000n;

module.exports = buildModule("BlsTokenModule", (m) => {
  // const unlockTime = m.getParameter("unlockTime", JAN_1ST_2030);
  const lockedAmount = m.getParameter("initialSupply", amount);

  const lock = m.contract("Lock", [unlockTime], {
    value: lockedAmount,
  });

  return { lock };
});
