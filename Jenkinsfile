pipeline {
    agent any
    stages {
        stage ('Checkout') {
            steps {
                checkout scm
            }
        }
        stage ('Download lcov converter') {
            steps {
                dir('demo_app'){
                    sh "curl -O https://raw.githubusercontent.com/eriwen/lcov-to-cobertura-xml/master/lcov_cobertura/lcov_cobertura.py"
                }
            }
        }
        stage ('Flutter Doctor') {
            steps {
                sh "flutter doctor -v"
            }
        }
        stage('Test') {
            steps {
                sh "flutter pub get"
                dir('demo_app'){
                    sh "flutter pub get"
                    sh "flutter test --coverage"
                }
            }
            post {
                always {
                    dir('demo_app'){
                        sh "python3 lcov_cobertura.py coverage/lcov.info --output coverage/coverage.xml"
                        step([$class: 'CoberturaPublisher', coberturaReportFile: 'coverage/coverage.xml'])
                    }
                }
            }
        }
        stage('Run Analyzer') {
            steps {
                sh "dartanalyzer --options analysis_options.yaml ."
            }
        }
        stage('Build APK') {
            steps {
                dir('demo_app'){
                    sh "flutter packages get"
                    sh "flutter build apk"
                }
            }
        }
    }
}