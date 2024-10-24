<template>
  <div class="opportunities">
   
    <!-- Accordion for Opportunities -->
    <div v-for="(opportunity, index) in opportunities" :key="opportunity.Opportunity.Id" class="accordion-item">
      <div class="accordion-header" @click="toggleAccordion(index)">
        <h2>{{ opportunity.Opportunity.Name }}                </h2>
        <span class="toggle-icon">{{ isOpen(index) ? '-' : '+' }}</span>
      </div>

      <div v-if="isOpen(index)" class="accordion-content">
        <table>
          <tr>
              <th>Stage</th>
              <th>Amount</th>
          </tr>
          <tr>
              <td>{{ opportunity.Opportunity.StageName }}</td>
              <td>${{ opportunity.Opportunity.Amount }}</td>
          </tr>
      </table>

        <!-- Nested Accordion for Quotes -->
        <div v-if="opportunity.Quotes.length">
          <h3>Quotes</h3>
          <div v-for="(quote, quoteIndex) in opportunity.Quotes" :key="quote.Quote.Id" class="quote-accordion-item">
            <div class="quote-accordion-header" @click="toggleQuoteAccordion(index, quoteIndex)">
              <strong>{{ quote.Quote.Name }}</strong>
              <span class="toggle-icon">{{ isQuoteOpen(index, quoteIndex) ? '-' : '+' }}</span>
            </div>

            <div v-if="isQuoteOpen(index, quoteIndex)" class="quote-accordion-content">
              <table>
                <tr>
                    <th>Total Price</th>
                </tr>
                <tr>
                    <td>${{ quote.Quote.TotalPrice }}</td>
                </tr>
            </table>

              <!-- Line Items for each Quote as a Table -->
              <div v-if="quote.QuoteLineItems.length">
                <h4>Line Items</h4>
                <table class="line-items-table">
                  <thead>
                    <tr>
                      <th>Quantity</th>
                      <th>Unit Price</th>
                      <th>Total Price</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="item in quote.QuoteLineItems" :key="item.Id">
                      <td>{{ item.Quantity }}</td>
                      <td>${{ item.UnitPrice }}</td>
                      <td>${{ item.TotalPrice }}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
              <p v-else>No line items available</p>
            </div>
          </div>
        </div>
        <p v-else>No quotes available</p>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    opportunities: Array, // Array of opportunities with quotes and line items
  },
  data() {
    return {
      openIndex: null, // Track which opportunity accordion item is open
      openQuotes: {}, // Track which quotes within each opportunity are open
    };
  },
  methods: {
    toggleAccordion(index) {
      this.openIndex = this.openIndex === index ? null : index; // Toggle opportunity open/close
    },
    isOpen(index) {
      return this.openIndex === index; // Check if the opportunity accordion item is open
    },
    toggleQuoteAccordion(opportunityIndex, quoteIndex) {
      const key = `${opportunityIndex}-${quoteIndex}`;
      this.$set(this.openQuotes, key, !this.openQuotes[key]); // Toggle quote open/close
    },
    isQuoteOpen(opportunityIndex, quoteIndex) {
      const key = `${opportunityIndex}-${quoteIndex}`;
      return !!this.openQuotes[key]; // Check if the quote accordion item is open
    },
  },
};
</script>

<style scoped>
.accordion-item {
  border: 1px solid #ddd; /* Border for each accordion item */
  margin-bottom: 10px; /* Space between items */
  border-radius: 4px; /* Rounded corners */
  background-color: #f9f9f9; /* Light background */
}

.accordion-header, .quote-accordion-header {
  padding: 10px; /* Padding for header */
  cursor: pointer; /* Pointer cursor on hover */
  display: flex; /* Flexbox for header layout */
  justify-content: space-between; /* Space between title and icon */
  align-items: center; /* Center items vertically */
}

.accordion-content, .quote-accordion-content {
  padding: 10px; /* Padding for content */
  border-top: 1px solid #ddd; /* Border between header and content */
}

h1 {
  margin-bottom: 20px; /* Space below the title */
}

h3, h4 {
  margin: 10px 0; /* Space above and below subheadings */
}

.quote-accordion-item {
  border: 1px solid #ddd; /* Border for each quote accordion item */
  margin-top: 10px; /* Space between quote items */
}

.line-items-table {
  width: 100%; /* Full width of the container */
  border-collapse: collapse; /* Collapse table borders */
}

.line-items-table th, .line-items-table td {
  border: 1px solid #ddd; /* Border for table cells */
  padding: 8px; /* Padding for table cells */
  text-align: left; /* Left align text */
}

.line-items-table th {
  background-color: #f2f2f2; /* Background for header cells */
}
</style>
