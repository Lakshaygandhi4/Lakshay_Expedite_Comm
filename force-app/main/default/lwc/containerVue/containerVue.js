import { LightningElement, api } from 'lwc';
import getOpportunitiesForAccount from '@salesforce/apex/OpportunityDataController.getOpportunitiesForAccount';
import createApp from 'c/vue'; // Importing createApp from your Vue setup

export default class ContainerVue extends LightningElement {
    @api recordId; // This is the Account ID from the record page
    vueApp;

    connectedCallback() {
        // Call the Apex method to get the data
        getOpportunitiesForAccount({ accountId: this.recordId })
            .then(result => {
                // Pass the data to the Vue.js app
                this.initializeVueApp(result);
            })
            .catch(error => {
                console.error('Error retrieving data', error);
            });
    }

    initializeVueApp(data) {
        console.log('Data received from Apex:', data); // Log data for debugging
        const vueContainer = this.template.querySelector('.vue-container'); // Select the container for Vue

        if (vueContainer) {
            // Vue all the things - three steps are needed
            // 1. Create a new div.
            const divEl = document.createElement("div");
            // 2. Append it to our lwc:dom=manual div.
            this.template.querySelector("div.vue").appendChild(divEl);
            // 3. Call `createApp` from `src/vue/main.js`
            this.vueApp = createApp(divEl, { opportunities: data });
            this.vueApp.mount(divEl); // Mount the app to the new div
        } else {
            console.error('Vue container not found. Ensure it is present in the HTML.');
        }
    }
}