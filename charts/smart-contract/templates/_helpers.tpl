{{/*
Expand the name of the chart.
*/}}
{{- define "smart-contract.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "smart-contract.fullname" -}}
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
{{- define "smart-contract.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "smart-contract.labels" -}}
helm.sh/chart: {{ include "smart-contract.chart" . }}
{{ include "smart-contract.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "smart-contract.selectorLabels" -}}
app.kubernetes.io/name: {{ include "smart-contract.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "smart-contract.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "smart-contract.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

###############
{{/*
The Name of the ConfigMap for the Anchoring SmartContract Data
*/}}
{{- define "smart-contract.configMapNameSmartContractInfo" -}}
{{- default (printf "%s-%s" (include "smart-contract.fullname" .) "scs-info") .Values.configMapNameSmartContractInfo }}
{{- end }}

{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts
*/}}
{{- define "smart-contract.namespace" -}}
  {{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}

{{- define "smart-contract.argsArray" -}}
{{- $args := list }}
{{- $args = append $args "--privateKey" -}}
{{- $args = append $args .Values.args.accountPrivateKey -}}
{{- $args = append $args "--rpcURL" -}}
{{- $args = append $args .Values.args.rpcURL -}}
{{- $mergedArgs := $args -}}
{{- dict "args" $mergedArgs | toJson }}
{{- end -}}