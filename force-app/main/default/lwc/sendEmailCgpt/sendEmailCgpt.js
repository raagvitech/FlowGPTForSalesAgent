import { LightningElement, track, api } from 'lwc';
import sendEmail from '@salesforce/apex/EmailHandler.sendEmail';
import processChatGPT from '@salesforce/apex/GptForEmail.processChatGPT';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SendEmailCgpt extends LightningElement {
    @track isModalOpen = false
    @api body;
    @track toAddress;
    @track fromAddress;
    @api subject;
    @api recordId;
    @track  emailFormat;
    @track isSpinner

    connectedCallback(){
        this.retrieveEmailFormat(this.recordId);
        this.isSpinner = true;
    }
    
    
   

    // Call the Apex method to fetch the email format

    retrieveEmailFormat(recordId) {
        console.log('inside'+recordId);
        processChatGPT({ recordId:this.recordId })
            .then(result => {
                this.emailFormat = result;
                // Log the email format to the console
                console.log('Email Format: ', this.emailFormat);
                this.body = this.emailFormat;
                this.isModalOpen = true;
                this.isSpinner = false;
            })
            .catch(error => {
                console.error('Error fetching email format: ', error);
                // Handle errors here
            });
    }


    handleChange(event){	
        if(event.target.name == 'toEmailAddress'){
            this.toAddress = event.target.value;
        }
        if(event.target.name == 'fromEmailAddress'){
            this.fromAddress = event.target.value; 
        }
        if(event.target.name == 'body'){
            this.body = event.target.value;

        }


    }

    submitDetails(){
        sendEmail({toAddress : this.toAddress, subject: this.subject, body:this.body}).then((result) => {
            
            this.isModalOpen = false;
            this.showToast();
          })
          .catch((error) => {
            this.showErrorToast();
            console.log('error---->', error);
            this.error = error;
          });

          
    }
    showErrorToast() {
        const evt = new ShowToastEvent({
            title: 'Error',
            message: 'Some unexpected error',
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    showToast() {
        const event = new ShowToastEvent({
            title: 'Email sent successfully',
            message: 'Email sent successfully',
            variant: 'success',
            mode: 'dismissable',
            messageData: [{

                url: 'https://raagvitechcom4-dev-ed.develop.lightning.force.com/lightning/r/Opportunity/'+this.recordId+'/view',
                
                label: 'Click Here',
                
                },]
        });
        this.body = '';
        this.toAddress = '';
        this.dispatchEvent(event);
    }

    closeModal(){
        this.isModalOpen =  false;
    }


}