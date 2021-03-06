package j_credential

// This file was generated by the swagger tool.
// Editing this file might prove futile when you re-run the swagger generate command

import (
	"net/http"
	"time"

	"golang.org/x/net/context"

	"github.com/go-openapi/errors"
	"github.com/go-openapi/runtime"
	cr "github.com/go-openapi/runtime/client"

	strfmt "github.com/go-openapi/strfmt"

	"koding/remoteapi/models"
)

// NewJCredentialFetchDataParams creates a new JCredentialFetchDataParams object
// with the default values initialized.
func NewJCredentialFetchDataParams() *JCredentialFetchDataParams {
	var ()
	return &JCredentialFetchDataParams{

		timeout: cr.DefaultTimeout,
	}
}

// NewJCredentialFetchDataParamsWithTimeout creates a new JCredentialFetchDataParams object
// with the default values initialized, and the ability to set a timeout on a request
func NewJCredentialFetchDataParamsWithTimeout(timeout time.Duration) *JCredentialFetchDataParams {
	var ()
	return &JCredentialFetchDataParams{

		timeout: timeout,
	}
}

// NewJCredentialFetchDataParamsWithContext creates a new JCredentialFetchDataParams object
// with the default values initialized, and the ability to set a context for a request
func NewJCredentialFetchDataParamsWithContext(ctx context.Context) *JCredentialFetchDataParams {
	var ()
	return &JCredentialFetchDataParams{

		Context: ctx,
	}
}

/*JCredentialFetchDataParams contains all the parameters to send to the API endpoint
for the j credential fetch data operation typically these are written to a http.Request
*/
type JCredentialFetchDataParams struct {

	/*Body
	  body of the request

	*/
	Body models.DefaultSelector
	/*ID
	  Mongo ID of target instance

	*/
	ID string

	timeout    time.Duration
	Context    context.Context
	HTTPClient *http.Client
}

// WithTimeout adds the timeout to the j credential fetch data params
func (o *JCredentialFetchDataParams) WithTimeout(timeout time.Duration) *JCredentialFetchDataParams {
	o.SetTimeout(timeout)
	return o
}

// SetTimeout adds the timeout to the j credential fetch data params
func (o *JCredentialFetchDataParams) SetTimeout(timeout time.Duration) {
	o.timeout = timeout
}

// WithContext adds the context to the j credential fetch data params
func (o *JCredentialFetchDataParams) WithContext(ctx context.Context) *JCredentialFetchDataParams {
	o.SetContext(ctx)
	return o
}

// SetContext adds the context to the j credential fetch data params
func (o *JCredentialFetchDataParams) SetContext(ctx context.Context) {
	o.Context = ctx
}

// WithBody adds the body to the j credential fetch data params
func (o *JCredentialFetchDataParams) WithBody(body models.DefaultSelector) *JCredentialFetchDataParams {
	o.SetBody(body)
	return o
}

// SetBody adds the body to the j credential fetch data params
func (o *JCredentialFetchDataParams) SetBody(body models.DefaultSelector) {
	o.Body = body
}

// WithID adds the id to the j credential fetch data params
func (o *JCredentialFetchDataParams) WithID(id string) *JCredentialFetchDataParams {
	o.SetID(id)
	return o
}

// SetID adds the id to the j credential fetch data params
func (o *JCredentialFetchDataParams) SetID(id string) {
	o.ID = id
}

// WriteToRequest writes these params to a swagger request
func (o *JCredentialFetchDataParams) WriteToRequest(r runtime.ClientRequest, reg strfmt.Registry) error {

	r.SetTimeout(o.timeout)
	var res []error

	if err := r.SetBodyParam(o.Body); err != nil {
		return err
	}

	// path param id
	if err := r.SetPathParam("id", o.ID); err != nil {
		return err
	}

	if len(res) > 0 {
		return errors.CompositeValidationError(res...)
	}
	return nil
}
