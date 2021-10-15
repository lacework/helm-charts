{{/*
Expand the name of the chart.
*/}}
{{- define "scanner.name" -}}
{{- default .Chart.Name .Values.name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "scanner.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "scanner.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "lacework-scanner.service-name" -}}
{{- printf "%s.%s.svc" (include "scanner.name" .) .Release.Namespace -}}
{{- end -}}

{{- define "serverCertificate" }}
{{- printf "%s" (required "A valid .Values.certsSecret.serverCertificate entry required" .Values.certs.serverCertificate) | replace "\n" "" }}
{{- end }}

{{- define "serverKey" }}
{{- printf "%s" (required "A valid .Values.certsSecret.serverKey entry required" .Values.certs.serverKey) | replace "\n" "" }}
{{- end }}

