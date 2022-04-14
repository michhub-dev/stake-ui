contract('MichToken', (accounts) => {
  let MichToken;
  const manyTokens = BigNumber(10).pow(18).multipliedBy(1000);
  const owner = accounts[0];
  const user = accounts[1];

  before(async () => {
    MichToken = await MichToken.deployed();
  });

  describe('Staking', () => {
      beforeEach(async () => {
        MichToken = await MichToken.new(
              owner,
              manyTokens.toString(10)
          );
      });
      it('createStaking creates a stake.', async () => {
        await MichToken.transfer(user, 3, { from: owner });
        await MichToken.createStaking(1, { from: user });

        assert.equal(await MichToken.balanceOf(user), 2);
        assert.equal(await MichToken.retrieveStake(user), 1);
        assert.equal(
            await MichToken.totalSupply(), 
            manyTokens.minus(1).toString(10),
        );
        assert.equal(await MichToken.totalStakes(), 1);
    });
    it('rewards are distributed.', async () => {
        await MichToken.transfer(user, 100, { from: owner });
        await MichToken.createStaking(100, { from: user });
        await MichToken.distributeBenefit({ from: owner });
       
        assert.equal(await MichToken.checkBenefit(user), 1);
        assert.equal(await MichToken.totalBenefit(), 1);
    });
    it('rewards can be withdrawn.', async () => {
        await MichToken.transfer(user, 100, { from: owner });
        await MichToken.createStaking(100, { from: user });
        await MichToken.distributeBenefit({ from: owner });
        await MichToken.withdrawBenefit({ from: user });
       
        const initialSupply = manyTokens;
        const existingStakes = 100;
        const mintedAndWithdrawn = 1;

        assert.equal(await MichToken.balanceOf(user), 1);
        assert.equal(await MichToken.retrieveStake(user), 100);
        assert.equal(await MichToken.checkBenefit(user), 0);
        assert.equal(
            await MichToken.totalSupply(),
            initialSupply
                .minus(existingStakes)
                .plus(mintedAndWithdrawn)
                .toString(10)
            );
            assert.equal(await MichToken.totalStakes(), 100);
            assert.equal(await MichToken.totalBenefit(), 0);
        });
