import {expect} from 'chai';
import {waffle, ethers} from "hardhat";
import {BigNumber, Contract, Signer, Wallet} from "ethers";

describe('Structure Inheritance Tests', function() {
  let admin: Signer;
  let structInheritance: Contract

  this.beforeAll(async () => {
    [admin] = await ethers.getSigners();
  })

  it("Should deploy of StructInheritance contract success", async () => {
    // given
    const factory = await ethers.getContractFactory("StructInheritance");

    // when
    structInheritance = await factory.connect(admin).deploy();

    // then
    expect(structInheritance.address).to.be.not.empty
  })

  it("Should calling extendedMappingTest() success", async () => {
      // when and then
      // all tests should be passed in the contract function itself
      await structInheritance.connect(admin).extendedMappingTest()
  })

  it("Should calling extendedArrayTest() success", async () => {
    // when and then
    // all tests should be passed in the contract function itself
    await structInheritance.connect(admin).extendedArrayTest()
  })

  it("Should calling extendedFunctionTest() success", async () => {
    // when and then
    // all tests should be passed in the contract function itself
    await structInheritance.connect(admin).extendedFunctionTest()
  })
})
