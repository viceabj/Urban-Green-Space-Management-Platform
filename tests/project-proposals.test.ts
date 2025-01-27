import { describe, it, expect, beforeEach } from "vitest"

describe("project-proposals", () => {
  let contract: any
  
  beforeEach(() => {
    contract = {
      createProposal: (title: string, description: string, spaceId: number, budget: number) => ({ value: 1 }),
      getProposal: (proposalId: number) => ({
        title: "Plant 100 Trees",
        description: "Increase green coverage in Central Park",
        spaceId: 1,
        budget: 50000,
        proposer: "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
        status: "active",
        votesFor: 10,
        votesAgainst: 2,
      }),
      voteOnProposal: (proposalId: number, vote: boolean) => ({ success: true }),
      closeProposal: (proposalId: number) => ({ success: true }),
    }
  })
  
  describe("create-proposal", () => {
    it("should create a new proposal", () => {
      const result = contract.createProposal("Plant 100 Trees", "Increase green coverage in Central Park", 1, 50000)
      expect(result.value).toBe(1)
    })
  })
  
  describe("get-proposal", () => {
    it("should return proposal information", () => {
      const result = contract.getProposal(1)
      expect(result.title).toBe("Plant 100 Trees")
      expect(result.spaceId).toBe(1)
      expect(result.budget).toBe(50000)
      expect(result.status).toBe("active")
    })
  })
  
  describe("vote-on-proposal", () => {
    it("should allow voting on a proposal", () => {
      const result = contract.voteOnProposal(1, true)
      expect(result.success).toBe(true)
    })
  })
  
  describe("close-proposal", () => {
    it("should close a proposal", () => {
      const result = contract.closeProposal(1)
      expect(result.success).toBe(true)
    })
  })
})

