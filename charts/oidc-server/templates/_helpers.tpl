{{/*
Expand the name of the chart.
*/}}
{{- define "oidc-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "oidc-server.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "oidc-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "oidc-server.labels" -}}
helm.sh/chart: {{ include "oidc-server.chart" . }}
{{ include "oidc-server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "oidc-server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "oidc-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "oidc-server.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "oidc-server.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "oidc-server.argsArray" -}}
{{- $args := list }}
{{- if ne (default "" .Values.args.clientId) "" -}}
  {{- $args = append $args "--clientId" -}}
  {{- $args = append $args .Values.args.clientId -}}
{{- end -}}
{{- if ne (default "" .Values.args.clientSecret) "" -}}
  {{- $args = append $args "--clientSecret" -}}
  {{- $args = append $args .Values.args.clientSecret -}}
{{- end -}}
{{- if ne (default "" .Values.args.scope) "" -}}
  {{- $args = append $args "--scope" -}}
  {{- $args = append $args .Values.args.scope -}}
{{- end -}}
{{- $grantTypes := .Values.args.grantTypes }}
{{- if ne (len $grantTypes) 0 -}}
  {{- $args = append $args "--grantTypes" -}}
  {{- range $index, $uri := $grantTypes -}}
  {{- $args = append $args $uri -}}
  {{- end -}}
{{- end -}}
{{- $responseTypes := .Values.args.responseTypes }}
{{- if ne (len $responseTypes) 0 -}}
  {{- $args = append $args "--responseTypes" -}}
  {{- range $index, $uri := $responseTypes -}}
  {{- $args = append $args $uri -}}
  {{- end -}}
{{- end -}}
{{- $redirectURIs := .Values.args.redirectURIs }}
{{- if ne (len $redirectURIs) 0 -}}
  {{- $args = append $args "--redirectURIs" -}}
  {{- range $index, $uri := $redirectURIs -}}
  {{- $args = append $args $uri -}}
  {{- end -}}
{{- end -}}
{{- if ne (default false .Values.args.usePKCE) false -}}
  {{- $args = append $args "--usePKCE" -}}
  {{- $args = append $args .Values.args.usePKCE -}}
{{- end -}}
{{- if ne (default "" .Values.args.providerURL) "" -}}
  {{- $args = append $args "--providerURL" -}}
  {{- $args = append $args .Values.args.providerURL -}}
{{- end -}}
{{- $mergedArgs := $args -}}
{{- dict "args" $mergedArgs | toJson }}
{{- end -}}

