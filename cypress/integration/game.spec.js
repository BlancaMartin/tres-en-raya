describe('The Home Page', function() {
  it('welcome the user', function() {
      cy.visit('/')
      cy.get(".title").should("contain", "Welcome to Tic Tac Toe")
  })
  it('loads the three modes to play', function() {
      cy.visit('/')
      cy.get(".mode").should("have.length", 3)
  })
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

describe('Game flow', function() {
  it('change turns', function() {
      cy.visit('/')
      cy.get("[data-label='human-vs-human']").click()
      cy.get(".transparent").should("contain", "X")
      cy.get("#cell-0").click()
      cy.get(".transparent").should("contain", "O")
  })

  it ('register players mark with its own colour', function() {
      cy.visit('/')
      cy.get("[data-label='human-vs-human']").click()
      cy.get("#cell-0").click()
      cy.get("#cell-1").click()

      cy.get("#cell-0").should("have.css", "color", "rgb(0, 0, 255)")
      cy.get("#cell-1").should("have.css", "color", "rgb(255, 0, 0)")

  })
})

describe('Random player', function() {
  it('successfuly register a random position', function() {
      cy.visit('/')
      cy.get("[data-label='human-vs-random']").click()
      cy.get("#cell-0").click()
      cy.get("[data-label='board']").find("[data-label='available']").should('have.length', 7)
  })
})

describe('Won game', function() {

  it('highlights the winning line', function() {
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

  it('congrats winner', function() {
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

  it('shows the restart game button', function() {
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

  it('announces draw', function() {
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

  it('shows the restart game button', function() {
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
