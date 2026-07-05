import { LightningElement } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import INCIDENT_REPORT_OBJECT from '@salesforce/schema/Incident_Report__c';
import INCIDENT_TYPE_FIELD from '@salesforce/schema/Incident_Report__c.Incident_Type__c';
import DESCRIPTION_FIELD from '@salesforce/schema/Incident_Report__c.Description__c';
import LOCATION_LATITUDE_FIELD from '@salesforce/schema/Incident_Report__c.Location_Latitude__c';
import LOCATION_LONGITUDE_FIELD from '@salesforce/schema/Incident_Report__c.Location_Longitude__c';
import ZIP_CODE_FIELD from '@salesforce/schema/Incident_Report__c.Location_Zip_Code__c';

export default class IncidentReportForm extends LightningElement {

    incidentType = '';
    description = '';
    zipCode = '';
    latitude = null;
    longitude = null;

    isLocating = false;
    isSubmitting = false;
    isSubmitted = false;
    hasLocation = false;
    locationError = false;
    locationStatus = '';

    // ─── Getters ─────────────────────────────────────────────────────────────

    get incidentTypeOptions() {
        return [
            { label: 'Pothole', value: 'Pothole' },
            { label: 'Broken Streetlight', value: 'Broken Streetlight' },
            { label: 'Graffiti', value: 'Graffiti' },
            { label: 'Fallen Tree', value: 'Fallen Tree' },
            { label: 'Water Leak', value: 'Water Leak' },
        ];
    }

    get locationButtonLabel() {
        return this.isLocating ? 'Getting Location...' : 'Get Current Location';
    }

    get locationButtonVariant() {
        return this.hasLocation ? 'brand' : 'neutral';
    }

    // ─── Input handlers ───────────────────────────────────────────────────────

    handleInputChange(event) {
        const field = event.target.name;
        if (field === 'incidentType') {
            this.incidentType = event.target.value;
        } else if (field === 'description') {
            this.description = event.target.value;
        } else if (field === 'zipCode') {
            this.zipCode = event.target.value;
        }
    }

    // ─── Geolocation ──────────────────────────────────────────────────────────

    handleGetLocation() {
        if (!navigator.geolocation) {
            this.locationError = true;
            this.locationStatus = 'Geolocation is not supported by your browser.';
            return;
        }

        this.isLocating = true;
        this.hasLocation = false;
        this.locationError = false;
        this.locationStatus = 'Requesting location permission...';

        navigator.geolocation.getCurrentPosition(
            (position) => {
                this.latitude = position.coords.latitude;
                this.longitude = position.coords.longitude;
                this.hasLocation = true;
                this.locationError = false;
                this.locationStatus = `Location captured: ${this.latitude.toFixed(4)}, ${this.longitude.toFixed(4)}`;
                this.isLocating = false;
            },
            (error) => {
                this.hasLocation = false;
                this.locationError = true;
                this.isLocating = false;
                switch (error.code) {
                    case error.PERMISSION_DENIED:
                        this.locationStatus = 'Location access denied. Please allow location access and try again.';
                        break;
                    case error.POSITION_UNAVAILABLE:
                        this.locationStatus = 'Location unavailable. Please try again.';
                        break;
                    case error.TIMEOUT:
                        this.locationStatus = 'Location request timed out. Please try again.';
                        break;
                    default:
                        this.locationStatus = 'An unknown error occurred while getting your location.';
                }
            },
            { enableHighAccuracy: true, timeout: 10000, maximumAge: 0 }
        );
    }

    // ─── Form validation ──────────────────────────────────────────────────────

    validateForm() {
        const inputs = [
            ...this.template.querySelectorAll('lightning-input'),
            ...this.template.querySelectorAll('lightning-textarea'),
            ...this.template.querySelectorAll('lightning-combobox')
        ];
        return inputs.reduce((valid, input) => {
            input.reportValidity();
            return valid && input.checkValidity();
        }, true);
    }

    // ─── Submit ───────────────────────────────────────────────────────────────

    async handleSubmit() {
        if (!this.validateForm()) return;

        this.isSubmitting = true;

        const fields = {
            [INCIDENT_TYPE_FIELD.fieldApiName]: this.incidentType,
            [DESCRIPTION_FIELD.fieldApiName]: this.description,
            [ZIP_CODE_FIELD.fieldApiName]: this.zipCode,
        };

        // Only stamp GPS coordinates if the user captured real location
        if (this.hasLocation) {
            fields[LOCATION_LATITUDE_FIELD.fieldApiName] = this.latitude;
            fields[LOCATION_LONGITUDE_FIELD.fieldApiName] = this.longitude;
        }

        try {
            await createRecord({ apiName: INCIDENT_REPORT_OBJECT.objectApiName, fields });
            this.isSubmitted = true;
        } catch (error) {
            const message = error?.body?.message || error?.message || 'An unexpected error occurred.';
            this.dispatchEvent(new ShowToastEvent({
                title: 'Submission Failed',
                message,
                variant: 'error',
                mode: 'sticky'
            }));
        } finally {
            this.isSubmitting = false;
        }
    }

    // ─── Reset ────────────────────────────────────────────────────────────────

    handleReset() {
        this.incidentType = '';
        this.description = '';
        this.latitude = null;
        this.longitude = null;
        this.zipCode = '';
        this.hasLocation = false;
        this.locationError = false;
        this.locationStatus = '';
        this.isSubmitted = false;
    }
}
