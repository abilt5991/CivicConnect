public virtual class TriggerHandler {
    
    protected TriggerOperation context;

    public TriggerHandler() {
        this.context = Trigger.operationType;
    }

    public void run() {
        switch on this.context {
            when BEFORE_INSERT { this.beforeInsert(); }
            when AFTER_INSERT { this.afterInsert(); }
            when BEFORE_UPDATE { this.beforeUpdate(); }
            when AFTER_UPDATE { this.afterUpdate(); }
        }
    }

    protected virtual void beforeInsert() {}
    protected virtual void afterInsert() {}
    protected virtual void beforeUpdate() {}
    protected virtual void afterUpdate() {}
}