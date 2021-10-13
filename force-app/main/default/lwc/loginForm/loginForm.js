import { LightningElement, wire} from 'lwc';
import getDataList from '@salesforce/apex/contactListViewHelper.getDataList';
import { NavigationMixin } from 'lightning/navigation';
import matchloginDetails from '@salesforce/apex/contactListViewHelper.matchloginDetails';

export default class LoginForm extends NavigationMixin(LightningElement) {

    enteredUserName;
    enteredPassword;
    isLogindetailsMatched = false;
    
    handleChange(event) {
        let field = event.target.name;
        if (field === 'userName') {
            this.enteredUserName = event.target.value;
        } else if (field === 'password') {
            this.enteredPassword = event.target.value;
        }
    }

    handleClick(){
        console.log('check handle click');
        console.log('enteredUserName ------ ',this.enteredUserName);
        console.log('enteredPassword ------ ',this.enteredPassword);
        
        matchloginDetails({userName : this.enteredUserName, pwd : this.enteredPassword})
        .then(result =>{
            console.log('check result', result);
             this.isLogindetailsMatched = result;
        })
        .catch(error =>{
            this.error = error;
        })
      
    }
     
    selectedObject;    
    error;
    dataList;
    
    columns = [
        {label: 'Name', fieldName: 'name', type: 'text',  sortable: true},
        {label: 'Id', fieldName: 'dataId', type: 'text', sortable: true},
        {label: 'Phone', fieldName: 'phone', type: 'text', sortable: true}
    ];
 

    selectionChangeHandler(event) {
        var selectedObject = event.target.value;

        this.selectedObject = selectedObject;
        this.selectedObjectName = selectedObject;

        getDataList({ 
            selectedObject : this.selectedObject
        })

        .then(result => {
            this.dataList = result;
        })
 
        .catch(error => {
            this.error = error;
        });
    }

    
    navigateToNewRecordPage(){
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: this.selectedObject,
                actionName: 'new'
            }
        })
    }
}