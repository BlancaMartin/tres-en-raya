describe('The Home Page', function() {
  it('successfully loads', function() {
      cy.visit('/')

      cy.get("[data-label='human-vs-human']").click()

      cy.get("[data-label='board']").should("be.visible")
  })


})
