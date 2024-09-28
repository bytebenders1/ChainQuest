import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";



const ChainQuestModule = buildModule("ChainQuestModule", (m) => {
  // Parameters for the ChainQuest contract


  // Deploy the ChainQuest contract
  const chainQuest = m.contract("ChainQuest", []);

  return { chainQuest };
});

export default ChainQuestModule;
//ChainQuestModule#ChainQuest - 0x15349C120dD1f071B3d3Ef9709fc6356c6CF9bB0