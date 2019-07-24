describe('The Home Page', function() {
  it('successfully loads board when playing human vs human', function() {
      cy.visit('/')
      cy.get("[data-label='human-vs-human']").click()
      cy.get("[data-label='board']").should("be.visible")
  })

  it('successfully loads board when playing human vs random', function() {
      cy.visit('/')
      cy.get("[data-label='human-vs-random']").click()
      cy.get("[data-label='board']").should("be.visible")
  })

  it('successfully loads board when playing human vs super', function() {
      cy.visit('/')
      cy.get("[data-label='human-vs-super']").click()
      cy.get("[data-label='board']").should("be.visible")
  })
})

describe('Random player', function() {
  it('Random player successfuly register a random position', function() {
      cy.visit('/')
      cy.get("[data-label='human-vs-random']").click()
      cy.get("#cell-0").click()
      cy.get("[data-label='board']").find("[data-label='available']").should('have.length', 7)
  })
})

describe('Won game', function() {

  it('Highlight the winning line', function() {
      cy.visit('/')
      cy.get("[data-label='human-vs-human']").click()
      cy.get("#cell-0").click()
      cy.get("#cell-5").click()
      cy.get("#cell-2").click()
      cy.get("#cell-6").click()
      cy.get("#cell-1").click()

      cy.get("#cell-0").should("have.css", "background-color", "rgb(255, 182, 193)")
      cy.get("#cell-1").should("have.css", "background-color", "rgb(255, 182, 193)")
      cy.get("#cell-2").should("have.css", "background-color", "rgb(255, 182, 193)")
  })

  it('Congrats winner', function() {
      cy.visit('/')
      cy.get("[data-label='human-vs-human']").click()
      cy.get("#cell-0").click()
      cy.get("#cell-5").click()
      cy.get("#cell-2").click()
      cy.get("#cell-6").click()
      cy.get("#cell-1").click()

      cy.get(".gameOverTitle").should("contain", "Congrats!")
      cy.get(".results").should("contain", "O won!")
  })

  it('Shows the restart game button', function() {
      cy.visit('/')
      cy.get("[data-label='human-vs-human']").click()
      cy.get("#cell-0").click()
      cy.get("#cell-5").click()
      cy.get("#cell-2").click()
      cy.get("#cell-6").click()
      cy.get("#cell-1").click()

      cy.get(".restartButton").should("be.visible")
  })
})

describe('Drawn game', function() {

  it('Announces draw', function() {
      cy.visit('/')
      cy.get("[data-label='human-vs-human']").click()
      cy.get("#cell-2").click()
      cy.get("#cell-0").click()
      cy.get("#cell-3").click()
      cy.get("#cell-5").click()
      cy.get("#cell-7").click()
      cy.get("#cell-4").click()
      cy.get("#cell-8").click()
      cy.get("#cell-6").click()
      cy.get("#cell-1").click()

      cy.get(".gameOverTitle").should("contain", "OOhhhhhh")
      cy.get(".results").should("contain", "It's a draw")
  })

  it('Shows the restart game button', function() {
      cy.visit('/')
      cy.get("[data-label='human-vs-human']").click()
      cy.get("#cell-2").click()
      cy.get("#cell-0").click()
      cy.get("#cell-3").click()
      cy.get("#cell-5").click()
      cy.get("#cell-7").click()
      cy.get("#cell-4").click()
      cy.get("#cell-8").click()
      cy.get("#cell-6").click()
      cy.get("#cell-1").click()

      cy.get(".restartButton").should("be.visible")
  })

})
