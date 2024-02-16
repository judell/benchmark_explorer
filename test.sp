dashboard "cis_v200_explorer" {

  title = "CIS V200 explorer"

  container {
    
    chart {
      width = 3
      type = "donut"
      title = "controls by status"
      sql = <<EOQ
        select status, count(*) 
        from cis_v200
        group by status
        order by count
      EOQ
      series "count" {
        point "alarm" {
          color = "red"
        }
        point "error" {
          color = "orange"
        }
        point "ok" {
          color = "green"
        }
        point "skip" {
          color = "gray"
        }
        point "info" {
          color = "blue"
        }

      }
    }

    chart {
      width = 3
      type = "donut"
      title = "controls by region"
      sql = <<EOQ
        select region, count(*) 
        from cis_v200
        group by region
        order by count
      EOQ
      series "count" {
        point "null" {
          color = "black"
        }
        point "error" {
          color = "orange"
        }
        point "ok" {
          color = "green"
        }
        point "skip" {
          color = "gray"
        }
        point "info" {
          color = "blue"
        }

      }
    }

    chart {
      width = 3
      type = "donut"
      title = "controls by control title"
      sql = <<EOQ
        select control_title, count(*) 
        from cis_v200
        group by control_title
        order by count
      EOQ
    }


    chart {
      width = 3
      type = "donut"
      title = "controls by type"
      sql = <<EOQ
        select cis_type, count(*) 
        from cis_v200
        group by cis_type
        order by count
      EOQ
    }

  }


  container {
    width = 6    
    title = "CIS v200 controls by control_title"

    input "control_title" {
      sql = <<EOQ
        select distinct on (title, control_title)
          control_title as label,
          control_title as value
        from cis_v200
        group by title, control_title
        order by title, control_title
      EOQ
    }

    table {
      args = [self.input.control_title]
      sql = <<EOQ
        select resource, title, control_title, status, account_id, region
        from cis_v200 
        where control_title = $1
        order by title, control_title
      EOQ
      column "control_title" {
        wrap = "all"
      }
    }

  }

  container {
    width = 6    
    title = "CIS v200 controls by resource"

    input "resource" {
      sql = <<EOQ
        select distinct
          resource as label,
          resource as value
        from cis_v200
        order by resource
      EOQ
    }

    table {
      args = [self.input.resource]
      sql = <<EOQ
        select resource, title, control_title, status, account_id, region
        from cis_v200 
        where resource = $1
        order by title, control_title
      EOQ
      column "control_title" {
        wrap = "all"
      }
    }

  }

  table {
    sql = <<EOQ
      select control_title, count(*)
      from cis_v200 
      group by control_title
      order by control_title
    EOQ
  }

  table "test" {
    type = "line"
    sql = <<EOQ
      select * from cis_v200 limit 1;
    EOQ
  }

}