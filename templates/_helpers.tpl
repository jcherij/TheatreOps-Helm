{{/*
MediQueue Helm helpers
*/}}

{{- define "mediqueue.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "mediqueue.fullname" -}}
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

{{- define "mediqueue.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "mediqueue.labels" -}}
helm.sh/chart: {{ include "mediqueue.chart" . }}
app.kubernetes.io/name: {{ include "mediqueue.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: mediqueue
data-sensitivity: phi
hipaa-scope: "true"
{{- end }}

{{- define "mediqueue.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mediqueue.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "mediqueue.apiSelectorLabels" -}}
{{ include "mediqueue.selectorLabels" . }}
app.kubernetes.io/component: api
{{- end }}

{{- define "mediqueue.workerSelectorLabels" -}}
{{ include "mediqueue.selectorLabels" . }}
app.kubernetes.io/component: worker
{{- end }}

{{- define "mediqueue.serviceAccountName" -}}
{{- printf "%s-sa" (include "mediqueue.fullname" .) }}
{{- end }}

{{- define "mediqueue.workerServiceAccountName" -}}
{{- printf "%s-worker-sa" (include "mediqueue.fullname" .) }}
{{- end }}

{{- define "mediqueue.postgresHost" -}}
{{- printf "%s-postgresql" .Release.Name }}
{{- end }}

{{- define "mediqueue.redisHost" -}}
{{- printf "%s-redis-master" .Release.Name }}
{{- end }}
